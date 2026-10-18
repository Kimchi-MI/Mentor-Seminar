package main

import "fmt"

func main() {
	var n int
	fmt.Print("Введите N (натуральное число): ")
	if _, err := fmt.Scan(&n); err != nil || n < 1 {
		fmt.Println("Ошибка: N должно быть целым числом >= 1")
		return
	}

	sum := 0
	for i := 1; i <= n; i++ {
		sum += i
	}
	average := float64(sum) / float64(n)

	fmt.Printf("Сумма чисел от 1 до %d: %d\n", n, sum)
	fmt.Printf("Среднее значение: %.2f\n", average)
}
