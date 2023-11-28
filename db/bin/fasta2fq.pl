#!usr/bin/perl

while(<>){
	chomp;
	if(/>/){
		#$count=1;
	#	$name=$_;
	#	$name=~s/>/@/;	
	#	print "$name\n"; 
		if(defined $seq ){
			print "$name\n";
			print "$seq\n";
			print "+\n";
			 $length=length($seq);
			$qua= "F" x $length;
			print "$qua\n";
		}
		$name=$_;
                $name=~s/>/@/;
		$seq="";
		$length=0;
	}else{
		$seq.=$_;
	#	$length+=length($seq);
		
	}
}
print "$name\n";
print "$seq\n";
print "+\n";
$length=length($seq);
$qua= "F" x $length;
print "$qua\n";

