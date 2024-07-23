#! /bin/bash

#Prints welcome message
echo
echo "------------------------------"
echo -e "Welcome to Password Manager!"
echo "------------------------------"
echo

#Options assigned to a variable for easier repeatability 
options="echo -e 'Please select from the following options:\n1. Enter a new password\n2. View a saved password\n3. Delete a password\n4. Exit Password Manager'"

#Evaluates user input and confirms choice to the user. Loop will only break on 1, 2, 3 and program will exit on 4.
while True; do
	eval $options #Present available options
	read -p "Enter your choice: " choice #Get input from user. 
	choice_message="You have selected"
	case $choice in
		1) choice_message="$choice_message 'Enter a new password'"
		echo $choice_message
		break;;
		2) choice_message="$choice_message 'View a saved password'"
		echo $choice_message
		break;;
		3) choice_message="$choice_message 'Delete a password'"
		echo $choice_message
		break;;
		4) choice_message="Goodbye!"
		echo $choice_message
		exit 1;;
		*) echo "Invalid choice. Please try again"; echo ; echo "------------------------------"; echo
	esac
done

