humano(platon).
humano(socrates).
humano(aristoteles).

mortal(Alguien) :- humano(Alguien).

mortal(elGalloDeAsclepio).

maestro(socrates,platon).
maestro(platon,aristoteles).

groso(Alguien):-
    maestro(Alguien,Uno),
    maestro(Alguien,Otro),
    Uno \= Otro.

/* === CONSULTAS ===
1 ?- mortal(Quien). "Quienes son mortales?"
Quien = platon ;
Quien = socrates ;
Quien = aristoteles 
Quien = elGalloDeAsclepio.

2 ?- humano(Quien). "Quienes son humanos?"
Quien = platon ;
Quien = socrates ;
Quien = aristoteles.

3 ?- groso(_). "Existe alguien groso?"
false.

4 ?- humano(elGalloDeAsclepio). "Es humano?"
false.

5 ?- maestro(platon,_). "Platon es maetro de alguno?"
true.

y asi se pueden hacer muchas mas consultas...

*/

% === Inversibilidad ===

odia(platon,diogenes).
odia(diogenes,_). % diogenes odia a todo el mundo

/*
Observar:


*/