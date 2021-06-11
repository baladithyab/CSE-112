sub factorial {

    my ($n) = @_;

    if ($n < 0){ return undef; }

    if ($n == 1 || $n == 0){

        return 1;

    }

    my $prod = factorial($n-1);

    return $n * $prod;

}