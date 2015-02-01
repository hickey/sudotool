sudotool
========

Tool for automating sudoer.d files and providing rights that expire within a specified timeframe.

[![Build Status](https://travis-ci.org/hickey/sudotool.svg?branch=master)](https://travis-ci.org/hickey/sudotool)

Usage
-----

    sudotool [options] filename

With the exception of the --purge option, a sudoer.d component filename must be specified. If the component file does not exist, it will be created. The full path to the file need not be specified, just a unique filename within the sudoers component directory (by default /etc/sudoers.d).
 

Options
-------

      --add USER
      -a USER

  Add the specified user to the given sudoer.d component file. This will not affect any other users already present in the component file and will not duplicate entry for the user. 
  
      --del USER
      --remove USER
      --rm USER
      -r USER

  Remove the user from the sudoer.d component file. This will remove all occurrences of the user in the file. 

      --runas USER
      -R USER

  Specify which effective user can be switched to by the user being added to the component file. If not specified it defaults to ALL. 

      --hostgrp NAME
      -H NAME

  Specify a host group that the user may execute sudo on. If not specified it defaults to ALL. Host groups should be setup in the master sudo configuration file (normally /etc/sudoers).

      --cmdgrp NAME
      --c NAME

  Specify a command group that may be executed under sudo by the user being added. If not specified it will default to ALL. Like host groups, command groups should be setup in the master sudo configuration file. 

      --expire TIMESPEC
      -x TIMESPEC

  Specify the time at which the sudoer.d component file will expire. The TIMESPEC parameter can be specified as a specific date as MM/DD or MM/DD/YY[YY] (e.g. 5/7, 1/1/15, or 12/31/2015). If only the MM/DD form is used, the correct year is calculated in comparison of the current date. So if by specifying MM/DD format for a date that has already passed, then the date for the following year will be used. 
  
  In addition, human readable durations may also be specified for the TIMESPEC. All durations are a numeric value with a one of the following characters appended: h (hours), d (days), w (weeks), m (months), or y (years). All durations are relative to the current date and time when the command is executed. The following are equivalent: 24h = 1d, 7d = 1w, 28d = 1m, 365d = 1y.

      --log FILE
      -l FILE

  Specify the location of a log file to keep track of transactions. Usually only used with the --purge option. 

      --convert FILE

  Read the specified sudoer file and copy the sudo right lines to the specified sudoer.d component file. Appropriate sudotool header lines are written to the sudoer.d component file and the expiration time can be set on the component file.

      --omit-user USERNAME
      -O USERNAME

  When converting a sudoer file to a sudoer.d component file, the --omit-user can be used to filter sudo rights for the specified username from being written to the component file. 

      --purge

  The purge option is usually called from cron on a regular interval (typically once per day) and will cause sudotool to scan the sudoer.d component files for files that have expired since the previous run of a purge. When an expired file is found it will have the permission bits changed to 000 to prevent the file from being read or used as part of sudo. This allows the sudo rights to be re-established by specifying a new expiration time. The purge option does not actually remove the component file.

      --basedir DIR

  Specify an alternative location for the sudoer.d component files. By default the location of the component files is /etc/sudoers.d, but on some installations this location may need to be specified to correctly identify the component files. 
  
Bugs
====

Sudotool is supported only under ruby 1.9.3 and greater. Because of issues with the DateTime class in ruby 1.8.7, sudotool will not run correctly without a moderate amount of work. If you are still running 1.8.7, you should jetison it now. If you provide a patch to make sudotool run under 1.8.7, I may accept it but don't count on it. 

Change Log
----------

| Version | Date       | Change                                           |
|:-------:|:----------:|--------------------------------------------------|
| 1.0.0   | 10/10/2013 | First production release                         |
| 1.1.0   | 10/28/2013 | Added rspec tests and --convert switch           |
| 1.1.1   | 1/30/2014  | Fixed generation of expires header. Added rainbow support |


Author
------

Gerard Hickey
hickey@kinetic-compute.com

