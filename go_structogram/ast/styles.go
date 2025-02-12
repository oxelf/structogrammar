package ast

type NodeStyle string

func Style() NodeStyle {
	return ""
}

func (s NodeStyle) String() string {
	return string(s)
}

func (s NodeStyle) BorderLeft() NodeStyle {
	return s + " border-left: 2px solid black;"
}

func (s NodeStyle) BorderRight() NodeStyle {
	return s + "border-right: 2px solid black;"
}

func (s NodeStyle) BorderTop() NodeStyle {
	return s + "border-top: 2px solid black;"
}

func (s NodeStyle) BorderBottom() NodeStyle {
	return s + "border-bottom: 2px solid black;"
}

func (s NodeStyle) BorderAll() NodeStyle {
	return s + "border: 2px solid black;"
}
