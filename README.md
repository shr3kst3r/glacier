# Puppet module for glacier-cmd

This puppet module installs the glacier-cmd from the [amazon-glacier-cmd-interface project](https://github.com/uskudnik/amazon-glacier-cmd-interface).  The glacier-cmd allows you to interact with Amazon's [Glacier](http://aws.amazon.com/glacier/) service.

## Supports

* CentOS and Redhat
* Ubuntu and Debian???

## Usage

    class { glacier:
        aws_access_key => '11223344',
        aws_secret_key => '55667788'
    }

or

    class { glacier:
        aws_access_key       => '11223344',
        aws_secret_key       => '55667788',
        glacier_config       => '/home/joe/.glacier-cmd',
        glacier_config_owner => 'joe',
        glacier_config_group => 'joe'
    }
## License

This module is licensed under the MIT license.

## Support

Please file bugs, comments, and patches at the [Github site](https://github.com/shr3kst3r/glacier)

