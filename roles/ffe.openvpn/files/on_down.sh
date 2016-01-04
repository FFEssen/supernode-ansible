#!/bin/sh
ip rule del from 10.228.0.0/24 table main
ip rule del to 10.228.0.0/24 table main
