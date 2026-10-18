package main

import "fmt"

func main() {
	var n int
	fmt.Print("Сколько чисел будете вводить? ")
	if _, err := fmt.Scan(&n); err != nil || n < 1 {
		fmt.Println("Ошибка: количество должно быть целым числом >= 1")
		return
	}

	var maxV, minV float64
	for i := 1; i <= n; i++ {
		var x float64
		fmt.Printf("Число %d: ", i)
		if _, err := fmt.Scan(&x); err != nil {
			fmt.Println("Ошибка: нужно ввести число")
			return
		}
		if i == 1 || x > maxV {
			maxV = x
		}
		if i == 1 || x < minV {
			minV = x
		}
	}

	fmt.Printf("Максимум: %g\nМинимум: %g\n", maxV, minV)
}
