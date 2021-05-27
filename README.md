# Asciify - Shopify Developer Intern Challenge (Fall 2021)

## What

       _____                .__.__  _____       
      /  _  \   ______ ____ |__|__|/ ____\__.__.
     /  /_\  \ /  ___// ___\|  |  \   __<   |  |
    /    |    \\___ \\  \___|  |  ||  |  \___  |
    \____|__  /____  >\___  >__|__||__|  / ____|
            \/     \/     \/             \/      
   is an image repository that transforms images into **ascii art**!
   
   Users can view a list of all uploaded images, upload their own and search for images by title and tags.
   
   **All photos in this README with exception of the shopify logo were taken by me**
   
## Getting up and running

Prerequisites: 
 - Configure ruby(v 2.6.7) and rails(5.2.5) [Outlined here](https://www.howtoforge.com/tutorial/ubuntu-ruby-on-rails/)
 - Install [ImageMagick](https://imagemagick.org/script/download.php) 6.9.12-10
 - Create database users and add their credentials in `config\database.yml` under the `default` section

Notes: 
 - [uru](https://bitbucket.org/jonforums/uru/wiki/Usage) can be used as a ruby version manager on windows, simply run `uru admin add RUBY/PATH/HERE` to register your ruby version and then `uru X.Y.Z` where X.Y.Z is your version of choice
 - If installing ImageMagick on windows, make sure to install in a path **with no spaces** and follow this [guide](https://github.com/rmagick/rmagick/wiki/Installing-on-Windows)
 - **ruby 2.6.7** with devkit (through [rvm](https://rvm.io/rvm/install) on unix or through [rubyinstaller](https://rubyinstaller.org/downloads/) on windows)

Setup:
  1. `git clone https://github.com/nmakhari/asciify.git`
  2. `cd asciify`
  3. `gem install bundler:2.2.16`
  4. `bundle install`
  5. `rails db:setup`
  6. `rails db:schema:load`
  7. `rails db:migrate RAILS_ENV=test` then `bundle exec rspec` to run tests, you should see the following
 ![tests](https://user-images.githubusercontent.com/55306725/117528466-7192b400-afa0-11eb-8622-f0dc8c8270da.jpg)
  9. `rails s`
  10. `rake jobs:work` to start the background worker
  11. Head to `http://localhost:3000/`!

## How
I created Asciify using **Ruby on Rails** because I wanted a taste of full stack development using a framework I have experience with while getting out of my comfort zone to build something that interests me!

Asciify was created using a **Ruby on Rails 5.2.5** backend and a [bootstrapped](https://getbootstrap.com/docs/4.0/getting-started/introduction/) HTML/CSS frontend, with RSpec for testing.

Notable libraries/gems:
 - [Rmagick](https://github.com/rmagick/rmagick) for image operations (needs ImageMagick to function)
 - [Active Storage](https://edgeguides.rubyonrails.org/active_storage_overview.html) to store images, see 'Next Steps' for design choices
 - [Ransack](https://github.com/activerecord-hackery/ransack) with [EasyAutoComplete](http://easyautocomplete.com/guide#sec-include) and [JQuery](https://rubygems.org/gems/jquery-rails/versions/4.3.1) for search functionality
 - [Pagy](https://github.com/ddnexus/pagy) for result pagination
 - [Delayed Job](https://github.com/collectiveidea/delayed_job) for image processing background jobs
 - [Rspec](https://github.com/rspec/rspec-rails) for testing!

## Screenshots / examples
The main feature of Asciify is creating great ascii art like this:

                              .,.,:,..
                            .,  ,. : ....
                            ,  ,...:::::;:...
                          .,,,::::::::::;oooo.
                       .::::::::::::::::ooooo:
                       ::::::..    ,::::ooooo;
                       ::::.       :::::oooooo.
                      .:::,   ,:::::::::oooooo,
                      ,:::,    .,:::::::oooooo;
                      :::::,.    .:::::;ooooooo
                      :::::::,    ,::::;ooooooo.
                     .:::. ...    :::::;ooooooo:
                     ,:::,.     .,:::::;ooooooo;
                     ,:::::::::::::::::ooooooooo.
                          ....,,,::::::oooo;;::,.
                                     ....                                                                       


                :%%.                         ox,  ,o%%o
                %#%                          oo. ,##;..
        .;x%%o .##oo%%o   :x%%x;  ,xx:x%x;  oxo x%##x;:xx. .xx:
        %#%... o##o,o##,.%#x.,%#x x##;,o##:.##; :##o..,##, x#x
        :%#%o  ##x  o## %#%   %#% ##o  :##,;##. o##.   %#;;#x
       .  :##;:##,  ##o %#%  o##,:##, ,##o %#x  %#x    ;#%#%
       x###%; x#%  :##, .x###%o. %#####x: ,##: ,##,    ,##x
                                .##:                 .;%#o
                                :%%.                 x%o.

Users are greeted with a list of all uploaded images:
![landing_page](https://user-images.githubusercontent.com/55306725/117527655-aa7c5a00-af9b-11eb-9bd1-f59e74852d5c.jpg)

Typing in the search bar **autocompletes** matches by title and tag:
![search_bar](https://user-images.githubusercontent.com/55306725/117527708-fdeea800-af9b-11eb-9846-d203091e909e.png)

Pressing the search button brings up a page with **all** matching results:
![search_page](https://user-images.githubusercontent.com/55306725/117527659-b10ad180-af9b-11eb-8e3c-0ed3e8359d05.jpg)

Clicking the 'Upload Image' button in the navigation bar brings up this form:
![new_upload](https://user-images.githubusercontent.com/55306725/117527657-acdeb400-af9b-11eb-8975-a46e5b9cbabf.jpg)

Clicking on an uploaded image shows some details and most importanty, it's ascii art!
![show_upload](https://user-images.githubusercontent.com/55306725/117527660-b23bfe80-af9b-11eb-8f69-ddc0332bf1cb.jpg)

## Next steps

Backend:
- Storing images locally is not scaleable and thus, I would use a cloud bucket storage solution like S3 in a production environment
- Adding user acounts/permissions is a logical way to gate the ability to upload images, users who are not signed in would be able to view only
- Using an ML library to auto-generate tags will result in a more predictable experience when searching and lift some responsibilty from the user

Frontend (excluding general UI work):
- Although eagerloading attachments and paginating result is already implemented, after migrating to a cloud storage solution I could explore lazy loading as the user scrolls to speed up the initial page load.
- Improvements to the image -> ascii conversion would be great! Right now the width of ascii art is set at 150 chars and there are only 10 available characters. Pixel intensities are mapped directly to the related ascii character. This [post](https://stackoverflow.com/a/32987834/15502383) has some really interesting strategies for leveraging the entire printable ascii set along with the shapes and pixel distributions of characters to increase the level of detail.

## Learnings
 - Rmagick is pretty well documented but suffers painfully from it's ImageMagick dependency, it was a pretty tedious process to find the version of ImageMagick that was compatible with the version of RMagick that also worked with my Rails version.
 - Updating my Ruby version before starting a project especially with a new version of Rails would have saved me hours of trouble.

## Bonus ascii :)
![anton_ascii](https://user-images.githubusercontent.com/55306725/117528153-bf0e2180-af9e-11eb-9f3d-f903a3f14431.jpg)
![avery_ascii](https://user-images.githubusercontent.com/55306725/117528195-f2e94700-af9e-11eb-823b-e38842304a29.jpg)
