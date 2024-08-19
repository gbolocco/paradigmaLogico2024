% receta(Nombre,ingrediente).
% ingrediente: [ingrediente(Nombre,Cantidad)].

receta(caramelo,[ingrediente(agua,100),ingrediente(azucar,100)]).

/*
1 ?- receta(Nombre,Ingrediente).
Nombre = caramelo,
Ingrediente = [ingrediente(agua, 100), ingrediente(azucar, 100)].

*/

/* === PREDICADOS DE LISTAS ===

1) member(Elemento,Lista) --> me devuelve si elemento existe en la lista.

?- member(5,[1,2,3,4]). 
false.

?- member(Elemento,[1,2,3,4]).
Elemento = 1 ;
Elemento = 2 ;
Elemento = 3 ;
Elemento = 4.

2) length(Lista,Tamaño).
?- length([1,2,3,4],4).
true.

?- length([1,2,3,4],Largo).
Largo = 4.

3) sumlist(Lista,Total). --> Sumatoria de la lista.

*/

% rapida(Receta) --> Tiene menos de 4 ingredientes
rapida(Receta):-
    receta(Receta,Ingredientes),
    length(Ingredientes,Total),
    Total < 3.

% postre(Receta) --> Tiene mas de 250 de azucar
postre(Receta):-
    receta(Receta,Ingredientes),
    member(ingrediente(azucar,Cantidad),Ingredientes),
    Cantidad > 250.

% findall(Selector,Consulta,Lista)

% findall(Nombre,receta(Nombre,Ingredientes),Recetas).

% cantidadDePostres(Receta) --> Se cumple para el numero de recetas de postre en la base de conocimiento.
cantidadDePostres(Cantidad):-
    findall(1,postre(Receta),Postres),
    sumlist(Postres,Cantidad).

% === Practica ===
calorias(Ingrediente,Calorias).

% trivial/1 --> Se cumple para las recetas con un unico ingrediente.
trivial(Receta):-receta(Receta,[_]).

% elPeor/2 --> Relaciona una receta con su ingrediente mas calorico.
elPeor(Ingredientes,Peor):-
    member(Peor,Ingredientes),
    calorias(Peor,CaloriasDelPeor),
    forall(member(Ingrediente,Ingredientes),(calorias(Ingredientes,Calorias),CaloriasDelPeor >= Calorias)).

% caloriasTotales/2 --> Relaciona una receta y su total de calorias.
caloriasTotales(Receta,CaloriasTotales):-
    receta(Receta,Ingredientes),
    findall(Caloria,(member(Ingrediente,Ingredientes) ,calorias(Ingrediente,Caloria)),Calorias),
    sumlist(Calorias,CaloriasTotales).

% versionLight/2 --> Relaciona una receta con sus ingredientes, sin el peor.
versionLight(Receta,IngredientesLight):-
    receta(Receta,Ingredientes),
    elPeor(Ingredientes,Peor),
    findall(Ing,(member(Ing,Ingredientes),Ing \= Peor),IngredientesLight).

% guasada/1 --> Se cumple para una receta con algun ingrediente de mas de 1000 calorias.
guasada(Receta):-
    receta(Receta,Ingredientes),
    member(IngredientEngordador,Ingredientes),
    calorias(IngredientEngordador,K),
    K >= 1000.
