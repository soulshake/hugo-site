---
author: Noah Zoschke
date: 2016-04-09T00:00:00Z
title: Massive Build Improvements
twitter: nzoschke
url: /2016/04/09/build-refactor/
---

This release continues the Convox tradition of offering a simple, reliable, private build service.

<!--more-->

We further this goal with a massive simplification of the build code. See PR #507 for code.

Most notably it removes the one build at a time limit. This limit was put in place to avoid transient errors that occur in the Docker registry when pushing two images at once. The occurrence of this error was already greatly reduced with the migration to ECR. The error is eliminated by adding a retry/backoff to the image push step.

The build script is now greatly simplified to match the fact that Convox builds are a very simple pipeline:

* create a new container
* extract source
* setup docker authentication
* docker pull
* docker build
* docker tag
* docker push
* callback to rack API with success or a failure reason

See https://github.com/convox/rack/blob/master/api/cmd/build/main.go for the simple pipeline implementation.

It also refactors the Rack build operations into a clearly defined interface:

* BuildCopy
* BuildCreateIndex
* BuildCreateRepo
* BuildCreateTar
* BuildDelete
* BuildGet
* BuildList
* BuildRelease
* BuildSave

These small units of build functionality are easier to write, easier to test, and easy to compose together for a clearly defined build API:

| Description       | Method                               |
|-------------------|--------------------------------------|
| List builds       | GET /apps/{app}/builds               |
| Create new build  | POST /apps/{app}/builds              |
| Get build info    | GET /apps/{app}/builds/{build}       |
| Update build info | PUT /apps/{app}/builds/{build}       |
| Delete a build    | DELETE /apps/{app}/builds/{build}    |
| Copy a build      | POST /apps/{app}/builds/{build}/copy |
| Get build logs    | GET /apps/{app}/builds/{build}/logs  |
