fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios vv_ipa_developer

```sh
[bundle exec] fastlane ios vv_ipa_developer
```

Sailor app VV INT Debug .ipa

### ios vv_ipa_release

```sh
[bundle exec] fastlane ios vv_ipa_release
```

Sailor app VV Prod Release .ipa

### ios vv_qa_tf

```sh
[bundle exec] fastlane ios vv_qa_tf
```

Upload VV Debug .ipa to testflight

### ios vv_prod_tf

```sh
[bundle exec] fastlane ios vv_prod_tf
```

Upload VV Release .ipa to testflight

### ios unlock_kc

```sh
[bundle exec] fastlane ios unlock_kc
```



### ios pod_install

```sh
[bundle exec] fastlane ios pod_install
```



### ios tests

```sh
[bundle exec] fastlane ios tests
```



### ios current_marketing_version

```sh
[bundle exec] fastlane ios current_marketing_version
```



### ios incr_ios_build_number

```sh
[bundle exec] fastlane ios incr_ios_build_number
```



### ios build_ipa

```sh
[bundle exec] fastlane ios build_ipa
```



### ios upload_tf

```sh
[bundle exec] fastlane ios upload_tf
```



----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
