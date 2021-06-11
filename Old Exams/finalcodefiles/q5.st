Array extend [
   monotonic: less [

      |array size num nextnum|

      array := self

      size := array size

      0 to: size do: [ :i |

         num := array at: i

         nextnum := array at i+1

         num nextnum perform:less

            ifFalse: [

             ^ false

            ].

      ].

      ^ true.

]