# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [2.1.0] - 2021-10-01
### Added
- `MessageBusClientWorker.subscribe(host, config)` which recommended over setting subscriptions via `configure`

## [2.0.0] - 2020-03-12
### Changed
- Update logging in Sidekiq; requires Sidekiq 6

## [1.2.2] - 2020-03-12
### Fixed
- ensure sidekiq `< 6` is installed, since `Sidekiq::Logging` is not available

## [1.2.1] - 2019-06-11
### Fixed
- conflicting last id when differentiating with headers

## [1.2.0] - 2018-02-24
### Added
- Add ability to customise client_id

## [1.1.1] - 2018-02-18
### Fixed
- Log channels correctly when `SubscriptionWorker` is performed.

## [1.1.0] - 2018-02-13
### Added
- Add a third argument support for processor which passes the request headers.

## [1.0.0] - 2018-02-12
### Changed
- Change structure of `subscriptions` config to include headers and channels.

## [0.4.0] - 2018-12-19
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
