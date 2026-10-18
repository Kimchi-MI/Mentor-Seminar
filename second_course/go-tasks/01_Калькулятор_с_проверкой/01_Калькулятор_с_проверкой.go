package main

import (
	"fmt"
)

func calculate(a float64, op string, b float64) (float64, error) {
	switch op {
	case "+":
		return a + b, nil
	case "-":
		return a - b, nil
	case "*":
		return a * b, nil
	case "/":
		if b == 0 {
			return 0, fmt.Errorf("Деление на ноль невозможно")
		}
		return a / b, nil
	default:
		return 0, fmt.Errorf("Неизвестная операция %q", op)
	}
}

func main() {
	var a, b float64
	var op string

	fmt.Print("Введите первое число: ")
	if _, err := fmt.Scan(&a); err != nil {
		fmt.Println("Ошибка - введите число")
		return
	}
	fmt.Print("Введите операцию (+, -, *, /): ")
	fmt.Scan(&op)
	fmt.Print("Введите второе число: ")
	if _, err := fmt.Scan(&b); err != nil {
		fmt.Println("Ошибка - введите число")
		return
	}

	result, err := calculate(a, op, b)
	if err != nil {
		fmt.Println("Ошибка - ", err)
		return
	}
	fmt.Printf("%g %s %g = %g\n", a, op, b, result)
}
