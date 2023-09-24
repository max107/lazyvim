package main

import "fmt"

type ITest interface {
}
type Test struct {
	A string
}

func testFn(a string, b bool) error {
	return nil
}

func main() {
	var test int = 1

	var hello ITest
	hello = Test{A: "Test"}

	if err := testFn("test", false); err != nil {
		panic(err)
	}

	test = 2
	fmt.Println("hello")
}
