#!/bin/bash
#Create a variable for the user input of the function he wants to run.
CHOICE=1

#function of main manu.
manu() {
	echo "-------------------------------------------------
Manu: 
1. Show Star Wars movie, create 7 users, create a new group and assign all users to the new group.
2. Provide a random citation as a pinguine for each existing users and save it in their home folder.
3. Create a new user for my friend.
4. Investigate failed logins.
5. Show my IP.
6. Test internet connection.
7. Download and install an app.
8. Find how many words exsits in a text file.
9. Show available wifi networks.
10.Exit.
Please enter a number in range of 1 - 10.
-------------------------------------------------"

	read CHOICE
}

#function to pick a function from the manu.
pick_function() {
	case "$CHOICE" in
	"1") function_one;;
	"2") function_two;;
	"3") function_three;;
	"4") function_four;;
	"5") function_five;;
	"6") function_six;;
	"7") function_seven;;
	"8") function_eight;;
	"9") function_nine;;
	"10") function_ten;;
	esac
}

function_one() {
	#Create a group.
	sudo -b groupadd newusers &
	
	#Loop that runs 7 times and each time it creates userx+1.
	for  i in {1..7};
	do
		sudo useradd -g newusers user$i -p "qwerty123" &
	done
	
	#Showing Star Wars movie.
	#Sometimes its working and sometimes its not :/
	telnet towel.blinkenlights.nl
}

function_two() {
	#Making sure that you can install the app.
	cd ~
	sudo apt-get install fortune cowsay 
	#for loop that scan passwd file and check if it got home folder, if yes it create a file.
	for user in $(cat /etc/passwd | grep home | cut -d':' -f 1); do
		if [ -d "/home/$user" ]; then
			RANDOMFORTUNNE=fortune
			$RANDOMFORTUNNE | cowsay -f tux
			$RANDOMFORTUNNE | cowsay -f tux > "/home/$user/citation.txt"
		fi
	done
	echo "two"
}

function_three() {
	#Create a user by input.
	FRIEND_USER=" "
	FRIEND_PASSWORD=" "
	
	echo "Please inset your friend user name : "
	read FRIEND_USER
	echo "Please inset your friend password : "
	read FRIEND_PASSWORD
	sudo useradd  $FRIEND_USER -p $FRIEND_PASSWORD
}

function_four() {
#Search for failed passwords logs and save them into the folder of the script.
sudo grep "Failed password" /var/log/auth.log
sudo grep "Failed password" /var/log/auth.log > $(dirname "$0")/failed_logins_logs.txt
}

function_five() {
#Search for the ip adresses and cuts the uneccesery fields.
echo "Your ip adress is:"
ifconfig | grep "inet " | cut -d' ' -f10
}

function_six() {
#Check ping to google, if true print "Connected".
if ping -c 1 google.com > /dev/null 2>&1 ; then
	echo "Connected"
else
	echo "Not connected"
fi
}

function_seven() {
USER_APT = 1

#Takes input and install app with dependencies.
cd ~
echo "Which app do you want to install ?"
read USER_APT
echo $USER_APT
sudo apt-get install -f $USER_APT 
}

function_eight() {
#Search for word in specific file and tells you how many times the word shows.
USER_WORD=" "
USER_FILE=" "

echo "Which word do you want to search ? "
read USER_WORD
echo "Paste full file path : "
read USER_FILE
cat $USER_FILE | grep $USER_WORD | wc -w
}

function_nine() {
WIFI_SSID=""
WIFI_PASSWORD=""
FLAG=0

#Check if there is interface wlo1, no print error, yes turn the flag on.
if ! nmcli d | grep -q "wlo1"; then
	echo "No wireless interface found"
	else
	FLAG=1
fi
#If the flag turns on it display all the available networks and takes input of which network to connect.
if [ $FLAG -eq 1 ]; then
	nmcli d wifi list
	echo "Which network do you want to log in? (type the same SSID)"
	read WIFI_SSID
	echo "What is the password of $WIFI_SSID?"
	read WIFI_PASSWORD
	nmcli d wifi connect $WIFI_SSID password $WIFI_PASSWORD
fi
}

function_ten() {
	exit
}

#main function
while true
 do
	manu
	pick_function
done