package main

import "fmt"

func main() {
	balance := 1000.0

	for {
		fmt.Println("1. Проверить баланс")
		fmt.Println("2. Пополнить счёт")
		fmt.Println("3. Снять деньги")
		fmt.Println("4. Выход")
		fmt.Print("Выберите операцию: ")

		var choice int
		if _, err := fmt.Scan(&choice); err != nil {
			fmt.Println("Ошибка - введите номер операции")
			var skip string
			fmt.Scanln(&skip) 
			continue
		}

		switch choice {
		case 1:
			fmt.Printf("Ваш баланс: %.2f\n", balance)
		case 2:
			var amount float64
			fmt.Print("Сумма пополнения: ")
			fmt.Scan(&amount)
			if amount <= 0 {
				fmt.Println("Сумма должна быть положительной")
				continue
			}
			balance += amount
			fmt.Printf("Счёт пополнен. Баланс: %.2f\n", balance)
		case 3:
			var amount float64
			fmt.Print("Сумма снятия: ")
			fmt.Scan(&amount)
			if amount <= 0 {
				fmt.Println("Сумма должна быть положительной")
			} else if amount > balance {
				fmt.Printf("Недостаточно средств. Баланс: %.2f\n", balance)
			} else {
				balance -= amount
				fmt.Printf("Выдано: %.2f. Баланс: %.2f\n", amount, balance)
			}
		case 4:
			fmt.Println("Спасибо, до свидания!")
			return
		default:
			fmt.Println("Неизвестная операция, выберите 1–4")
		}
	}
}
