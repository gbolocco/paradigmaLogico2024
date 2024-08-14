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