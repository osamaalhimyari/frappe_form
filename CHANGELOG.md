The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Types of changes
- `Added` for new features.
- `Changed` for changes in existing functionality.
- `Deprecated` for soon-to-be removed features.
- `Removed` for now removed features.
- `Fixed` for any bug fixes.
- `Security` in case of vulnerabilities.

## 0.2.1
### Changed
- Improved answer generation to ignore null values.

### Fixed
- Fixed issue with DocFieldPhoneView parsing initial phone number with hyphens.
- Fixed issue with DocFieldGeolocationView initial value that was taking coordinates in the wrong order.
- Fixed issue with scroll controller when using multiple tabs.

## 0.2.0
### Added
- Added "Next" and "Back" buttons to the `DocForm` for easier navigation between tabs.
- Added support for html formatting on descriptions and Heading.

### Changed
- Changed the description location on Sections and Columns to be below the title instead of below the content.

### Fixed
- Fixed an issue with the label on Checkbox fields.

## 0.1.2
### Changed
- `html_editor_enhanced` dependency updated to latest.

## 0.1.1
### Fixed
- Fixed an issue with the `DocFieldRatingView` that was not setting the initial rating correctly. 

## 0.1.0
### Added
- Added support for `actions` widgets on AppBar.
- Fields sorted according to the `field_order` property in the `DocForm`.

### Changed
- `DocFieldAutocompleteView` updated to show options on focus.

## 0.0.1
### Added
- First release