package util

func RemoveBraces(s string) string {
	if len(s) < 2 {
		return s
	}
	if s[0] == '(' {
		s = s[1:]
	}
	if s[len(s)-1] == ')' {
		s = s[:len(s)-1]
	}
	return s
}
