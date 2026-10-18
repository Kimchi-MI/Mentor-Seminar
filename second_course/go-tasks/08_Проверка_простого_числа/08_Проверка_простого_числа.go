package main

import "fmt"

func isPrime(n int) bool {
	if n < 2 {
		return false
	}
	for i := 2; i*i <= n; i++ {
		if n%i == 0 {
			return false
		}
	}
	return true
}

func main() {
	var n int
	fmt.Print("Введите целое число: ")
	if _, err := fmt.Scan(&n); err != nil {
		fmt.Println("Ошибка - нужно ввести целое число")
		return
	}
	if isPrime(n) {
		fmt.Printf("%d — простое число\n", n)
	} else {
		fmt.Printf("%d — не простое число\n", n)
	}
}
