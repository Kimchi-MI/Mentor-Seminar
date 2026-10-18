package main

import "fmt"

func isS(x int) bool {
	return x > 0 && x%2 == 0
}

func main() {
	var n int
	fmt.Print("Сколько чисел будете вводить? ")
	if _, err := fmt.Scan(&n); err != nil || n < 1 {
		fmt.Println("Ошибка - количество должно быть целым числом больше 0!")
		return
	}

	sum := 0
	for i := 1; i <= n; i++ {
		var x int
		fmt.Printf("Число %d: ", i)
		if _, err := fmt.Scan(&x); err != nil {
			fmt.Println("Ошибка - нужно ввести целое число")
			return
		}
		if isS(x) {
			sum += x
		}
	}

	fmt.Println("Сумма подходящих чисел (положительных и чётных):", sum)
}
