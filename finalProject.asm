.data 
welcome: .asciiz "Welcome to the Maleh vending machine!\n"
moneyEnter: .asciiz "\nHow much would you like to enter?\n(Minimum $1.00, Maximum $20.00)\nEnter the amount: $"
snackArray: .word 5, 5, 5, 5, 5, 5, 5, 5, 5
ui0: .asciiz "|-------------------------------------------------------------------------------------------------------|\n"
ui1: .asciiz "|1 - Famous Amos         $2.50  | 2 - Lay's Chips Original $3.50  | 3 - Pop's Secret Popcorn     $3.00  |\n"
ui2: .asciiz "|4 - Dasani Water        $3.00  | 5 - Coca-Cola            $3.50  | 6 - Jarritos Mandarin Soda   $4.25  |\n"
ui3: .asciiz "|7 - Maleh Gumball (Red) $10.00 | 8 - Maleh Gumball (Blue) $10.00 | 9 - Maleh Gumball (Orange) - $10.00 |\n"
nopeInput: .asciiz "Insert quarters or up to $20 bills."
yesInput: .asciiz "Choose a snack."
minimum: .float 0.25
maximum: .float 20.00

.globl main
.text
# Setting the $0.25 minimum
lwc1 $f0, minimum
  
# Seting the $20.00 maximum
lwc1 $f1, maximum

# Welcome the user to the vending machine
li $v0, 4
la $a0, welcome
syscall
# Print the vending machine
j printVend
#Print the vending machine
printVend:
  li $v0, 4
  la $a0, ui0
  syscall
  li $v0, 4
  la $a0, ui1
  syscall
  li $v0, 4
  la $a0, ui2
  syscall
  li $v0, 4
  la $a0, ui3
  syscall
  li $v0, 4
  la $a0, ui0
  syscall
  
# Prompt the user to enter the amount of money
# Label to repeat entering money
main:
  enter:
  li $v0, 4
  la $a0, moneyEnter
  syscall

  # Take in the user's input
  li $v0, 7
  syscall
  move $v0, $t0 # Move input to $t0
  # Storing the input into a floating point variable
  mtc1 $t0, $f2 # Move input to $f2
  j isLess
  syscall
  
  isLess:
     # Check if the input is less than $0.25
     c.lt.s $f2, $f0 # Is the input less than the minimum?
     bc1t invalidInput # Invalidate if yes
     bc1f isGreater # Check if greater than 20 if no
    
  isGreater:
    # Branch to main if more than $20.00
    c.lt.s $f2, $f1 # Is the input less than the maximum
    bc1t invalidInput # Invalidate if no
    bc1f validInput # Validate if yes
    
    # In case of innvalid response
    invalidInput:
    li $v0, 4
    la $a0, nopeInput
    syscall
    j exit
    
    # In case of valid response
    validInput: 
    li $v0, 4
    la $a0, yesInput
    syscall

exit:
li $v0, 10
syscall