a := #(16rFF #foo 'bar' 3.141592653589793).
1 to: a size do: [:i | stdout << i << ': ' << a at: i << Character nl]
