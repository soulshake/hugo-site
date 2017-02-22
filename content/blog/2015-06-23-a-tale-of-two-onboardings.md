---
author: Matt Manning
date: 2015-06-23T00:00:00Z
title: A Tale of Two Onboardings
twitter: mattmanning
url: /2015/06/23/a-tale-of-two-onboardings/
---

Joe is a junior developer starting his first real programming job for the photo sharing site SendFace. He arrives at the office Monday morning and meets Susan, his engineering manager. After a quick tour of the office, Susan hands Joe a shiny new Macbook Pro. Joe asks if there are any new developer docs.  

“No, unfortunately,” says Susan, “but it’s a pretty standard Rails app. It shouldn’t be too hard to get going. Let me know if you need help.”

<!--more-->

He sits down at his desk, excited to check out the app and dive into his work. The code is stored in a private Github repo, so Joe installs Homebrew and then git and clones the project.

Excited to get the app running, he types

`$ rails server`

but he’s met with an error message. There are missing gems. _Oh right_, Joe thinks, _I have to install the dependencies. No biggie. I’ll just bundle install some gems and get going._

`$ bundle install`

A different error message appears this time. Bundler isn’t installed.

`$ gem install bundler`

That works._ Yay! Now I can install the rest of the gems_, Joe thinks, relieved.

`$ bundle install`

Another error. The default OS X ruby is old and doesn’t match the version specified in the Gemfile. Joe has some ideas for how to remedy this, but he’s fresh out of a Rails boot camp, working on software team for the first time, and he wants to fit in, so he wanders over to Susan’s desk.

“Hey Susan. It looks like I need to upgrade some software on my Macbook. What does the rest of the team use for managing ruby versions?”

Susan sighs deeply. “Well, Jill uses rbenv and says that anything else is a waste . . . But Dan is totally in the rvm camp and can’t be budged. Just use whatever you like. In the end it’s not that big of a deal.”

Joe heads back to his desk. After some brief head scratching he settles on rvm. He installs it and waits while Ruby 2.2.2 downloads and builds. After several minutes the new Ruby is ready to go.

`$ bundle install`

Yet another error! This time a system dependency for compass failed to build. He’s a little confused, but decides not to bug Susan again. He doesn’t want to look like a total noob asking so many questions just to get started.

After some Googling, Joe realizes the gem is failing to build extensions, because he doesn’t have gcc installed. Eventually, he figures out he needs to download and install the Xcode command line tools. That takes what feels like forever, but finally finishes. Exasperated, Joe gets ready to run Bundler again. _It _**_has_**_ to work this time_, he thinks.

`$ bundle install`

Aaaand it fails. Joe puts his head down on his desk and takes a minute to collect himself. _This is your first day on the job, Joe! You can’t give up this easily. Take a deep breath and read the error message._

Thankfully, the error message is descriptive, and Joe quickly discovers that rmagick failed to install, because ImageMagick isn’t installed on his laptop. The most popular Stack Overflow answer says to use Homebrew to install it.

`$ brew install ImageMagick`

More waiting . . .

`$ bundle install`

Bundler finally finishes. Elated, Joe starts up the app:

`$ rails server`

But he’s met with more error messages. SendFace is a [12-factor app](http://12factor.net/config), so it expects the configuration to be stored in the local environment rather than in environment config files. The app is failing because DATABASE_URL isn’t set.

Joe consults with his coworker, Dan, and figures out that he needs to install PostgreSQL. [There are 5 different ways to install it](http://www.postgresql.org/download/macosx/). Dan says to use Homebrew.

`$ brew install postgres`

Oof. This is going to take a while. It’s almost lunchtime now, so Joe steps away from his desk, hoping he can finish this and get some “real work” done in the afternoon.

After lunch the PostgreSQL install has finished. He reads the output and figures out how to get launchctl to manage starting postgres. Dan helps him construct DATABASE_URL correctly. Now it’s finally time to start the app!

`$ rails server`

The app boots! Joe does a little dance in his desk chair before he realizes someone might be watching.

He migrates the database and starts clicking around the app. He tries to apply a filter to one of the sample photos, but the app throws an error message. Apparently filters are applied via Sidekiq background jobs, and not only is the Sidekiq worker not running, there is no Redis to store the jobs in the first place.

Joe installs Redis via Homebrew and starts it up in a separate Terminal tab. He also starts the Sidekiq worker in another tab, but then realizes he needs to set REDIS_URL. Requiring him to manually restart the web and worker processes again.

He now has six Terminal tabs going to work on this app:

*   web process (Rails)
*   tailing logs/development.log
*   worker (Sidekiq)
*   redis
*   vim
*   bash prompt for everything else

What a headache! Joe starts on his first development task from the issue tracker, but he’s so mentally exhausted that he doesn’t get anywhere with it._Oh well_, he thinks at the end of the day, _I’ll get a fresh start tomorrow._

Joe tries to stay optimistic, even though he knows he’ll have to go through a very similar process to bootstrap his dev environment for any of SendFace’s other apps.

* * *

On the other side of the city, on the same day, Janelle is starting her first real job at photo-sharing rival YouGram. She also gets a shiny new Macbook Pro. She installs Homebrew and then git and clones the core app.

Janelle asks her manager, Mike, if there are any new developer docs.

“No, unfortunately,” he says, “but we use containerization for everything, so you just need to install Docker and Compose. Grab one of the other developers if you need help.”

Janelle gets Rebecca, one of the senior developers, to help her set things up.

The project has a [Dockerfile](https://docs.docker.com/reference/builder/) specifying everything about the operating system and dependencies, so she just needs Docker on her system.

Rebecca tells her to install [boot2docker](http://boot2docker.io/) using the OS X installer, and run the setup commands:

`$ boot2docker init`

`$ boot2docker start`

`$ eval “$(boot2docker shellinit)”`

Rebecca points out that the app has a [docker-compose.yml](https://docs.docker.com/compose/yml/) file explaining all of the processes and how they connect. It references Postgres and Redis images on [Docker Hub](https://hub.docker.com/) that can be automatically fetched and run. It has defaults for all of the required environment variables.

Janelle installs [docker-compose](https://docs.docker.com/compose/):

`$ brew install docker-compose`

Then she starts the project.

`$ docker-compose up`

Janelle now has a fully functioning app with all of the runtimes, system dependences, supporting services, and environment variables set correctly. Outputs streams from all of the processes are multiplexed in a single Terminal tab.

If she wants to run any of the other YouGram apps she can just clone them and start them with a single command:

`$ docker-compose up`

Janelle grabs a task from the issue tracker and starts working.

It’s not even 10am yet.

Across town, Joe is still Googling Bundler errors.
