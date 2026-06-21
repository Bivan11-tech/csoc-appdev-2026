package utils

func GetDiscount(code string, subtotal float64) float64 {
	switch code {
	case "WELCOME10":
		return subtotal * 0.10
	case "SAVE50":
		return 50
	default:
		return 0
	}
}