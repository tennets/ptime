#!/usr/bin/env bash
# ptime - a basic pomodoro timer
#
# MIT License
#
# Copyright (c) 2024 Stephan Gahima
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


PROG="ptime"
VERSION="0.0.1"
AUTHOR="@tennets (GitHub)"
POMODORO="\xF0\x9F\x8D\x85"
OK="\xE2\x9C\x93"


# Default values
DEFAULT_FOCUS_TIME=25
DEFAULT_SHORT_BREAK_TIME=5
DEFAULT_LONG_BREAK_TIME=15
DEFAULT_POMODORO_CYCLE_LENGTH=4

# Code status
_SUCCESS_PTIME=0
_FAILURE_PTIME=1
_FAILURE_UPDATE_STARTUP_FILES=2

NC="\033[0m"        # no color
BRED="\033[1;31m"   # bold red
BCYAN="\033[1;96m"  # bold cyan  
GREEN="\033[0;32m"  # green
BGREEN="\033[1;32m" # bold green

# Main function
# usage: ptime [options] [start]
# see '_usage_msg' for more information
function ptime
{
	_START="start"

	# Global flags
	_FH="-h"
	_FF="-f"
	_FS="-s"
	_FL="-l"
	_FC="-c"

	# Parse required arguments
	if [ $# -eq 0 ]; then

		echo "${BCYAN}$PROG${NC}: ${BRED}missing required arguments${NC}.";
		_usage_msg; 
		return $_FAILURE;

	fi

	if [ "$1" = "$_START" ]; then

		# Set default values if environment variables are not set
		export _FTIME=${PTIME_FOCUS_TIME:-$DEFAULT_FOCUS_TIME}
		export _SBTIME=${PTIME_SHORT_BREAK_TIME:-$DEFAULT_SHORT_BREAK_TIME}
		export _LBTIME=${PTIME_LONG_BREAK_TIME:-$DEFAULT_LONG_BREAK_TIME}
		export _PCLENGTH=${PTIME_POMODORO_CYCLE_LENGTH:-$DEFAULT_POMODORO_CYCLE_LENGTH}

		_start_cycle $_FTIME $_SBTIME $_LBTIME $_PCLENGTH
		return $_SUCCESS

	elif [ "$1" = "$_FH" ]; then

		_usage_msg; 
		return $_SUCCESS;

	elif [ "$1" = "$_FF" ] || [ "$1" = "$_FS" ] ||\
	     [ "$1" = "$_FL" ] || [ "$1" = "$_FC" ]; then
	
		_update_startup_files $1 $2; 

	else

		echo "${BCYAN}$PROG${NC}: ${BRED}invalid option${NC}.";
		_usage_msg; 
		return $_FAILURE;

	fi
}


# Print usage message
# usage: _usage_msg 
function _usage_msg
{
	echo "$PROG - a basic $POMODORO timer (v.$VERSION)"
	echo ""
	echo "usage: $PROG [options] [start]"		  
	echo "options:"
	echo "  -h                show this help message and exit"
	echo "  -f TIME           set focus time to TIME minutes, default"\
		 "is $DEFAULT_FOCUS_TIME"
	echo "  -s TIME           set short break time to TIME minutes,"  \
		 "default is $DEFAULT_SHORT_BREAK_TIME"
	echo "  -l TIME           set long break time to TIME minutes,"   \
		 "default is $DEFAULT_LONG_BREAK_TIME"   
	echo "  -c N_UNITS        set pomodoro cycle to N_UNITS $POMODORO"\
	     "units, default is $DEFAULT_POMODORO_CYCLE_LENGTH"
	echo ""
	echo "by $AUTHOR"
}


# Update startup files
# usage: _update_startup_files <env_var_name> <value>
#        <env_var_name> : name of the environment variable
#        <value>        : value of the environment variable
function _update_startup_files
{
	_BASHRC_FILE=~/.bashrc
	_BASH_PROFILE_FILE=~/.bash_profile

	# Check if value is a positive integer
	if [ $2 -ge 0 ]; then

		# Check if environment variables are already set;
		# if not, add them to the '~/.bashrc' and '~/.bash_profile' files
		if [ "$1" = "$_FF" ]; then

			_env_var_name="PTIME_FOCUS_TIME"
			echo "${BCYAN}$PROG${NC}: ${BGREEN}$OK${NC}"\
			     "${GREEN}focus time set to $2 minutes${NC}."; 

		elif [ "$1" = "$_FS" ]; then

			_env_var_name="PTIME_SHORT_BREAK_TIME"
			echo "${BCYAN}$PROG${NC}: ${BGREEN}$OK${NC}"\
			     "${GREEN}short break time set to $2 minutes${NC}."; 

		elif [ "$1" = "$_FL" ]; then

			_env_var_name="PTIME_LONG_BREAK_TIME"
			echo "${BCYAN}$PROG${NC}: ${BGREEN}$OK${NC}"\
			     "${GREEN}long break time set to $2 minutes${NC}.";

		elif [ "$1" = "$_FC" ]; then

			_env_var_name="PTIME_POMODORO_CYCLE_LENGTH"
			echo "${BCYAN}$PROG${NC}: ${BGREEN}$OK${NC}"          \
			     "${GREEN}pomodoro cycles before long break set to $2"\
			     "$POMODORO units${NC}.";

		fi

		_ust "$_env_var_name" "$2" "$_BASHRC_FILE"	
		_ust "$_env_var_name" "$2" "$_BASH_PROFILE_FILE"

		echo "${BCYAN}$PROG${NC}: ${BGREEN}$OK${NC} ${GREEN}$_env_var_name"\
			 "successfully updated${NC} in '$_BASHRC_FILE' and"            \
			 "'$_BASH_PROFILE_FILE' files."
		return $_SUCCESS;

	else

		echo "${BCYAN}$PROG${NC}: ${BRED}invalid value${NC}."; 
		return $_FAILURE_UPDATE_STARTUP_FILES;

	fi
}


# Update startup files helper function
# usage: _ust <env_var_name> <value> <startup_file> 
#        <env_var_name> : name of the environment variable
#        <value>        : value of the environment variable
#        <startup_file> : startup file to update
function _ust
{
	if ! grep -q "$1" "$3"; then
		echo "export $1=$2" >> "$3"
	fi
}


# Start a pomodoro cycle
# usage: _start_cycle <focus_time> <short_break_time> <long_break_time> <pomodoro_cycle>
#        <focus_time>       : focus time in minutes
#        <short_break_time> : short break time in minutes
#        <long_break_time>  : long break time in minutes
#        <pomodoro_cycle>   : number of pomodoro cycles before long break
function _start_cycle
{
	# Cycle counter
	_cc=0

	# Start a pomodoro cycle
	while : ; do

		_current_pomodoro_cycle=$(( $_cc + 1 ))

		_countdown $1 "FOCUS" $_current_pomodoro_cycle

		(( _cc++ ))

		# Break out if this is the last unit of the cycle
		if [ $_cc -eq $4 ]; then
			break
		fi

		_countdown $2 "SHORT BREAK" $_current_pomodoro_cycle

	done
	_countdown $3 "LONG BREAK"
}


# Countdown timer
# usage: _countdown <start_time> <phase> <cycle_counter>
#        <start_time>    : start time in minutes
#        <phase>         : phase of the pomodoro cycle
#		 <cycle_counter> : current pomodoro cycle
function _countdown
{
	_ONESEC=1
	_SEC2MIN=60
	_SEC2HR=3600

	# Start time in seconds
	_stsec=$(( $1 * $_SEC2MIN ))

	while [ $_stsec -gt 0 ]; do

		# Convert seconds to minutes and seconds
		_min=$(( $_stsec % $_SEC2HR / $_SEC2MIN ))
		_sec=$(( $_stsec % $_SEC2MIN ))

		# Check if seconds and minuts are 0
		if [ $_min -eq 0 ] && [ $_sec -eq 0 ]; then
			break
		fi

		clear 
		if [ $# -eq 2 ]; then
			echo "${BCYAN}$PROG${NC}: end of the cycle; take a"\
			     "${BGREEN}$2${NC}"
		else
			echo "${BCYAN}$PROG${NC}: ${BGREEN}$2${NC}"
			for (( i=0; i<$3; i++ )); do
				echo -n "$POMODORO"
			done 
			echo "\n"
		fi
		printf "%02d:%02d\n" $_min $_sec
		sleep $_ONESEC
		
		(( _stsec-- ))

	done	
	_timer_alarm
}


# Play sound when time is up
# usage: _timer_alarm
function _timer_alarm
{
	tiu="Time is up"
	if [ "$(uname)" = "Darwin" ]; then
		say -v Zarvox -r 1.25 $tiu
	elif [ "$(uname)" = "Linux" ]; then
		# generated on macOS with 'say -v Zarvox -r 1.25 -o timeisup.wav --data-format=LEF32@32000 $tiu'
		paplay timeisup.wav
	fi
}
