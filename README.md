# Edible

Smith College
Am I Edible? [Example project]

## Environment Configuration
Follow the general steps in the next section to set up your local development environment from scratch. It is essential that you **consult a more detailed guide** that corresponds to your specific type of development machine. Use one of the guides listed below to help you complete the steps for setting up Edible on your machine.

* [Install RoR on Mac](https://mac.install.guide/ruby/index.html)
* [Install RoR on Windows 10](https://gorails.com/setup/windows/10)

On Mac it is strongly recommended that you use asdf to install Ruby. On Windows you should set up your environment through the Windows Subsystem for Linux (WSL). The guides above explain how to do so in detail.

## General Configuration Steps

As you configure your environment you should **keep a log** where you **write down all the steps you take** and each command you type. You will inevitably run into errors setting up your development environment and maintaining a meticulous log will allow others to help you troubleshoot. 
 
**1. Fork & clone Edible repo**
* Click fork in the upper right hand corner of the Edible GitHub page
* Then create a local copy of your fork with:
* `git clone https://github.com/<username>/edible.git`

**2a. Install MySQL 8 (on Mac)**
* Download: https://dev.mysql.com/downloads/mysql
* Be sure to select the version that corresponds to your operating system (Intel Mac = x86, M1 Mac = ARM)
* Choose "Use Legacy Password Encryption" when installing
* Make note of the password you set for the root user
* After install make sure you add `/usr/local/mysql/bin` (or equivalent) to your path

**2b. Install MySQL 8 (on Windows)**
* From WSL run: `sudo apt-get install mysql-server mysql-client libmysqlclient-dev`
* Then use `sudo mysql` to enter the MySQL console without a password
* Type `alter user 'root'@'localhost' identified with mysql_native_password by '<password>';` to set a password
* Then apply it with `flush privileges;` followed by `exit;`
* Try logging in with `mysql -u root -p` to confirm the password for the root user

**3. Install Ruby 3.0.2**
* Consult one of the guides linked in the previous section
* Use [asdf](https://asdf-vm.com/guide/getting-started.html) on Mac/Linux systems
* Use the [WSL](https://docs.microsoft.com/en-us/windows/wsl) on Windows systems
* Make sure you are using Ruby 3.0.2 before proceeding:
  * `cd edible` then `ruby -v` to check your version

**4. Install essential gems**
* Disable gem docs:
  * `echo "gem: --no-document" >> ~/.gemrc`
* Install Rails 6.1.5:
  * `gem install rails --version 6.1.4`
* Install MySQL gem:
  * `gem install mysql2`
  * Use the `-- --with-opt-dir="$(brew --prefix openssl@1.1)"` flag on M1 Macs
* Install required gems:
  * `bundle install`

**5. Configure database environment variables**
* Add a file called `.env` to your app's root directory
* Ensure that it includes the credentials you setup when installing MySQL:

```shell
MYSQL_USERNAME=root
MYSQL_PASSWORD=YOURPASSWORD
MYSQL_SOCKET=/tmp/mysql.sock              # For Mac
MYSQL_SOCKET=/var/run/mysqld/mysqld.sock  # For Windows
```

**6. Prepare database in MySQL**
* `rake db:create`

**7. Run database migrations**
* `rake db:migrate`

**8. Confirm app runs**
* Launch web server using `rackup` or `rails s`
* If using `rackup` open http://localhost:9292 (or http://127.0.0.1:9292) in a browser
* If using `rails s` open http://localhost:3000 (or http://127.0.0.1:3000) in a browser
* You should see the Edible start page
