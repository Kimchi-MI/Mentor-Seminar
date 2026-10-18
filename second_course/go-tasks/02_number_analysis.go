package main

import "fmt"

func main() {
	var n int
	fmt.Print("Введите целое число: ")
	if _, err := fmt.Scan(&n); err != nil {
		fmt.Println("Ошибка: нужно ввести целое число")
		return
	}

	// Знак
	switch {
	case n > 0:
		fmt.Println("Число положительное")
	case n < 0:
		fmt.Println("Число отрицательное")
	default:
		fmt.Println("Число равно нулю")
	}

	// Четность
	if n%2 == 0 {
		fmt.Println("Число чётное")
	} else {
		fmt.Println("Число нечётное")
	}

	// На 3 и 5
	if n%3 == 0 {
		fmt.Println("Делится на 3")
	} else {
		fmt.Println("Не делится на 3")
	}
	if n%5 == 0 {
		fmt.Println("Делится на 5")
	} else {
		fmt.Println("Не делится на 5")
	}
}
