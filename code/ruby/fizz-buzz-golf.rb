## theirs
1.upto(100){|n|puts'FizzBuzz
'[i=n**4%-15,i+13]||n}
## theirs, char reference
1.upto(100){|n|puts'FizzBuzz '[i=n**4%-15,i+13]||n}

## mine
100.times{|n|puts'FizzBuzz '[i=n**4%-15,i+13]||n}

## perl
die+map{(Fizz)[$_%3].(Buzz)[$_%5]||$_}1..100

1
2
fizz
4
buzz
fizz
7
8
fizz
buzz
11
fizz
13
14
fizz


## n=n => nil trick
[n=n]*2<<:fizz
[n=n]*2+[:fizz,n,:buzz]
[n=n,n]+[:fizz,n,:buzz]
[n=n,n,:fizz,n,:buzz]*20
(([n=n]*4<<:fizz)*20).zip([n,n,:buzz]*34)

f[]+b[]


1.upto(?d){|n|p 'FizzBuzz'[i=n**4%-15,i+13]||n}
1.upto(100){|n|p 'FizzBuzz'[i=n**4%-15,i+13]||n}

1.upto(100){|x|p  x%3==0?'fizz':x%5==0?'buzz':x}
100.times{|n|p 'FizzBuzz '[i=n**4%-15:i+13]||n}

c=0;([n=nil,n,'fizz',n,'buzz']*20).map{|x|x||c+=1}
v=[n=nil,n,'fizz',n,'buzz'];1.upto(100){|x|v[x%5]}

t=[n=nil,n,:fizz];f=t[0..1]+[n,n,:buzz]
[n=nil,n,'fizz',n,'buzz']
['fizz','buzz',*[nil]*3]

puts ([n=n,n,:fizz]*34).zip([*[n]*4,:buzz]*20)
[n=n]*100


z='zz'
z=?z*2


'fibu'[]
[:fi,:bu][]
x%3==0?'fizz':x%5==0?'buzz'

(1..100).map{|x|x%3==0?'fizz':x%5==0?'buzz':x}
(1..100).map{|x|x%3==0?'fizz':x%5==0?'buzz':x}


1.upto(100){|n|puts'FizzBuzz
'[i=n**4%-15,i+13]||n}

100.times{|n|puts'FizzBuzz
'[i=n**4%-15,i+13]||n}

100.times{|n|puts'FizzBuzz '[i=n**4%-15,i+13]||n}

(1..100).map{|n|'FizzBuzz'[i=n**4%-15,i+13]||n}

(1..100).map{|x|x%3==0?:fizz:x%5==0?:buzz:x}
(1..100).map{|x|x%3=0?'fi':x%5=5?'bu':x+'zz'}
(1..100).map{|x|"#{x%3=0?'fi':x%5=5?'bu':x+'zz'}

(1..).map{|x|x%3=0?'fizz':x%5=5?'buzz':x}

1.upto(?d){|n|puts'FizzBuzz'[i=n**4%-15,i+13]||n}
