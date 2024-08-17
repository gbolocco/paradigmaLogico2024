% habitat(Animal,Bioma) aridad 2, completamente inversible
habitat(jirafa,sabana).
habitat(hipopotamo,sabana).
habitat(tigre,sabana).
habitat(tigre,bosque).
habitat(tiburon,mar).
habitat(atun,mar).
% ...  

% acuatico(Animal).
acuatico(Animal) :- habitat(Animal,mar). 

% terrestre(Animal) :- not(habitat(Animal,mar)).
terrestre(Animal) :- not(habitat(Animal,mar)).

/*  !!! Notar que el not no es inversible, animal entra sin ligar

1 ?- acuatico(Animal). ¿Cuales animales son acuaticos?
Animal = tiburon ;
Animal = atun.

2 ?- terrestre(Animal). WTF...
false.

*/

% Para esto deberia ligar la variable Animal antes de que llegue al not

animal(Animal) :- habitat(Animal,_). % Defino que todo animal tiene un habitat

terrestre2(Animal) :- 
    animal(Animal),
    not(habitat(Animal,mar)).

/* Ahora si

1 ?- terrestre2(Animal).
Animal = jirafa ;
Animal = hipopotamo ;
Animal = tigre ;
Animal = tigre ;
false.

*/
% =====

habitat(foca,costa).
habitat(foca,tundra).
% templado(Bioma).
templado(costa).

% friolento(Animal).
friolento(Animal):-
    habitat(Animal,Bioma),
    templado(Bioma).

/*
1 ?- habitat(foca,Bioma).
Bioma = costa ;
Bioma = tundra.

2 ?- friolento(foca).
true --> RESPUESTA INCORRECTA, YA QUE LA TUNDRA NO ES TEMPLADA
*/

% === Predicado forall/2 ===
friolento2(Animal):-
    animal(Animal), % con esta linea ligo la variable
    forall(habitat(Animal,Bioma),templado(Bioma)).
/*
1 ?- friolento2(foca).     
false. --> AHORA SI.
*/

% === PRACTICA ===

% come(Comedor,Comido).
come(Comedor,Comido).

% 1) hostil
hostil(Animal,Bioma):-
    animal(Animal),
    habitat(_,Bioma),
    forall(habitat(OtroAnimal,Bioma),come(OtroAnimal,Animal)).

% 2) terrible
terrible(Animal,Bioma):-
    animal(Animal),
    habitat(_,Bioma),
    forall(come(OreoAnimal,Animal),habitat(OtroAnimal,Bioma)).

% 3) compatibles
compatibles(UnAnimal,OtroAnimal):-
    animal(UnAnimal),
    animal(OtroAniaml),
    not(come(UnAnimal,OtroAnimal)),
    not(come(OtroAnimal,UnAnimal)).

% 4) adaptable
adaptable(Animal):-
    animal(Animal),
    forall(habitat(_,Bioma),habitat(Animal,Bioma)).

% 5) raro
raro(Animal):-
    habitat(Aniaml,Bioma),
    not((habitat(Animal,OtroBioma), Bioma \= OtroBioma)).

% 6)dominante
dominante(Animal):-
    habitat(Animal,Bioma),
    forall(habitat(OtroAnimal,Bioma),come(Animal,OtroAnimal)).