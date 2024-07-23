#! /bin/bash
echo
echo "----------"
echo -e "Welcome to Password Manager!\nPlease select from the following options:"
echo "----------"
echo -e "1. Enter a new password.\n2. View a saved password\n3. Delete a password\n4. Exit Password Manager"

choice_message=""

while True;
do
	read choice
	case $choice in
		1) choice_message="You selected 'Enter a new password'"
		echo $choice_message
		break;;
		2) choice_message="You selected 'View a saved password'"
		echo $choice_message
		break;;
		3) choice_message="You selected 'Delete a password'"
		echo $choice_message
		break;;
		4) choice_message="Goodbye!"
		echo $choice_message
		break;;
		*) echo "Invalid choice. Please try again"
	esac
done


