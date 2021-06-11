Array extend [
    binSearch: val left: l right: r [
        |arr iter|
        arr := self.
        l = r ifTrue: [^ -1].
        iter := (r + l) // 2.
        stdout << (arr at: iter).
        (arr at: iter) = val ifTrue: [^iter].
        (arr at: iter) < val
            ifTrue:[^ self binSearch: val left: l right: iter]
            ifFalse: [^ self binSearch: val left: iter right: r]
    ]
    binSearch: value[
        ^self binSearch: value left: 1 right: (self size)
    ]
]

arr := #(3 6 9 10).
" stdout << arr size. "
res := arr binSearch: 10 left: 1 right: 4.
stdout << res