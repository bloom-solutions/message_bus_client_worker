# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Changed
- Change to excon. We know how to stream with that (make way for long polling)

### Fixed
- Remove SidekiqUniqueJobs that sometimes caused this to never run

## [0.3.1] - 2018-10-07
### Fixed
- SubscriptionWorker retry is `0` so death handlers are executed

## [0.3.0] - 2018-09-24
### Added
- Log details of enqueued subscription

### Fixed
- Remove locks when jobs die

## [0.2.2] - 2018-09-15
### Fixed
- Problem where only one of two subscription workers were enqueued. Previous "fix" didn't work

## [0.2.1] - 2018-09-14
### Fixed
- Fix problems enqueuing more than one SubscriptionWorker

## [0.2.0] - 2018-08-08
### Changed
- Ability to specify what message_id to start from

## [0.1.0] - 2018-08-07
### Added
- Initial release
