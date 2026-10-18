package main

import "fmt"

func main() {
	var n int
	fmt.Print("Сколько чисел будете вводить? ")
	if _, err := fmt.Scan(&n); err != nil || n < 1 {
		fmt.Println("Ошибка: количество должно быть целым числом >= 1")
		return
	}

	positive, negative, zeros := 0, 0, 0
	for i := 1; i <= n; i++ {
		var x float64
		fmt.Printf("Число %d: ", i)
		if _, err := fmt.Scan(&x); err != nil {
			fmt.Println("Ошибка: нужно ввести число")
			return
		}
		switch {
		case x > 0:
			positive++
		case x < 0:
			negative++
		default:
			zeros++
		}
	}

	fmt.Printf("Положительных: %d\nОтрицательных: %d\nНулей: %d\n", positive, negative, zeros)
}
