# hive-capture

## Set up

ImageMagick is required for the rmagick gem, used for the graphs, so this must be
installed first, together with some development libraries:

    sudo apt-get install imagemagick libmagickcore-dev libmagickwand-dev

After this, the dependencies can be installed:

    bundle install

## Using Apache

Install Passenger using http://recipes.sinatrarb.com/p/deployment/apache_with_passenger

Add the following lines to your Apache config:

```apacheconf
<VirtualHost *:80>
  ServerName www.yourhost.com
  # !!! Be sure to point DocumentRoot to 'public'!
  DocumentRoot /path/to/hive-capture/public
  <Directory /path/to/hive-capture/public>
    # Set environment as required
    SetEnv HIVE_ENVIRONMENT production
    SetEnv RACK_ENV production

    # This relaxes Apache security settings.
    AllowOverride all
    # MultiViews must be turned off.
    Options -MultiViews
    # Uncomment this if you're on Apache >= 2.4:
    #Require all granted
  </Directory>
</VirtualHost>
```

## Using thin

To run:

    rackup

or, to run in the background,

    rackup -D

## Running behind a proxy

To configure the Apache server to redirect to the a thin server running on port
9292, configure Apache as follows:

```apacheconf
<VirtualHost *:80>
  <Proxy *>
    Order deny,allow
    Allow from all
  </Proxy>
  ProxyRequests Off
  ServerName example.com
  ProxyPass / http://localhost:9292/
  ProxyPassReverse / http://localhost:9292/
</VirtualHost>
```
