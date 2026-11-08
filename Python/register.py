shopperprice = float(input("Insert the cost of your groceries: "))
shopperpay = float(input("Insert paid amount: "))
tax = shopperprice*(0.12)
change = shopperpay - shopperprice
bonus = (shopperprice/20)*0.05
print("Here is the amount of your change",change)
print("Here is the added tax price",tax)
print("Here is your additional bonus per 20 euros",bonus)
