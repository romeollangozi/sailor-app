//
//  VectorImage.swift
//  Voyages
//
//  Created by Chris DeSalvo on 12/29/23.
//

import SwiftUI

private class VectorImageView: UIView {
	private var pdf: CGPDFDocument?
	private var page: CGPDFPage?
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	init(url: URL) {
		super.init(frame: CGRect())
		self.isOpaque = false
		update(url: url)
	}
	
	func update(url: URL) {
		if let pdf = CGPDFDocument(url as CFURL) {
			self.pdf = pdf
			if let page = pdf.page(at: 1) {
				self.page = page
			}
		}
	}
	
	func drawVector(rect: CGRect, context: CGContext) {
		guard let box = self.page?.getBoxRect(.mediaBox) else {
			return
		}
		
		guard let page = page else {
			return
		}
	
		context.translateBy(x: 0, y: rect.size.height)
		context.scaleBy(x: 1, y: -1)
		
		if contentMode == .scaleAspectFit {
			let scale = min(rect.size.width / box.size.width, rect.size.height / box.size.height)
			let x = rect.origin.x + (rect.size.width / 2 - (box.size.width * scale) / 2)
			let y = (rect.size.height / 2 - (box.size.height * scale) / 2) - rect.origin.y
			let transform = CGAffineTransform(a: scale, b: 0, c: 0, d: scale, tx: x, ty: y)
			context.concatenate(transform)
		} else {
			let a = rect.size.width / box.size.width
			let d = rect.size.height / box.size.height
			let x = 0.0
			let y = 0.0
			let transform = CGAffineTransform(a: a, b: 0, c: 0, d: d, tx: x, ty: y)
			context.concatenate(transform)
		}

		context.drawPDFPage(page)
	}
	
	func image(size: CGSize) -> Image {
		let renderer = UIGraphicsImageRenderer(size: size)

		let image = renderer.image { ctx in
			drawVector(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height), context: ctx.cgContext)
		}
		
		return Image(uiImage: image)
	}
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		
		if let context = UIGraphicsGetCurrentContext() {
			drawVector(rect: rect, context: context)
		}
	}
}

private struct VectorImageRepresentable : UIViewRepresentable {
	var url: URL
	var contentMode: ContentMode
	
	func makeUIView(context: Context) -> UIView {
		let view = VectorImageView(url: url)
		view.contentMode = contentMode == .fit ? .scaleAspectFit : .scaleToFill
		return view
	}
	
	func updateUIView(_ uiView: UIView, context: Context) {
		let vectorImageView = uiView as? VectorImageView
		vectorImageView?.update(url: url)
		vectorImageView?.setNeedsDisplay()
	}
}

struct VectorImage: View {
	private var url: URL
	private var mode: ContentMode

	init?(name: String, mode: ContentMode? = nil) {
		self.mode = mode ?? .fit
		if let url = Bundle.main.url(forResource: name, withExtension: "pdf") {
			self.url = url
		} else {
			return nil
		}
	}
	
	init(url: URL) {
		self.url = url
		self.mode = .fit
	}

	var body: some View {
		VectorImageRepresentable(url: url, contentMode: mode)
	}
}

#Preview {
//	VectorImage(name: "Wallet Pattern", mode: .fill)
		//.aspectRatio(contentMode: .fit)
	VectorImage(name: "Wavy", mode: .fill)
		.frame(height: 100)
		.background(Color(uiColor: .gray))
}
