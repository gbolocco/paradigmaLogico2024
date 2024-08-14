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

/* Observar:
1 ?- odia(platon,Alguien).
Alguien = diogenes.

2 ?- odia(diogenes,Alguien).
true.
- Esta consulta no es inversible
*/

% === Aritmetica ===

siguiente(N,S) :- S is N + 1.

/*
1 ?- siguiente(41,Sig).
Sig = 42.
*/

% === Practica 2 ===
/*Dado el predicado inversu¿ible padre/2 definir los predicados:
abuelo/2, hermano/2, ancestro/2 */

% padre(Padre,Hijo).
padre(abraham,homero).
padre(homero,bart).

% abuelo(Abuelo,Nieto) "Es completamente inversible"
abuelo(Abuelo,Nieto) :- 
    padre(Abuelo,Padre),
    padre(Padre,Nieto).

% hermano(Hermano1,Hermano2)
hermano(Hermano1,Hermano2):-
    padre(Padre,Hermano1),
    padre(Padre,Hermano2),
    Hermano1 \= Hermano2. % si esta linea se encuentra en la primera o segunda linea del predicado, deja de ser inversible

% ancestro(Ancestro,Descendiente) requerimos recursividad
ancestro(Ancestro,Descendiente) :- padre(Ancestro,Descendiente).
ancestro(Ancestro,Descendiente) :- 
    padre(Ancestro,Alguien),
    ancestro(Alguien,Descendiente).