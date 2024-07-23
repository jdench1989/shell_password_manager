#! /bin/bash
echo
echo "----------"
echo -e "Welcome to Password Manager!\nPlease select from the following options:"
echo "----------"
echo -e "1. Enter a new password.\n2. View a saved password\n3. Delete a password\n4. Exit Password Manager"

read choice

choice_message=""

case $choice in
	1) choice_message="You selected 'Enter a new password'";;
	2) choice_message="You selected 'View a saved password'";;
	3) choice_message="You selected 'Delete a password'";;
	4) choice_message="Goodbye!";;
	*) echo "Invalid choice. Please try again"
esac

echo $choice_message
