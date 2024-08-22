rata(remy, gusteaus).
rata(emile, bar).
rata(django, pizzeria).

cocina(linguini, ratatouille, 3).
cocina(linguini, sopa, 5).
cocina(colette, salmonAsado, 9).
cocina(horst, ensaladaRusa, 8).

trabajaEn(gusteaus, linguini).
trabajaEn(gusteaus, colette).
trabajaEn(gusteaus, skinner).
trabajaEn(gusteaus, horst).
trabajaEn(cafeDes2Moulins, amelie).

% -------------------------------------------------------------

/*
1. inspeccionSatisfactoria/1 se cumple para un
restaurante cuando no viven ratas allí.
*/

inspeccionSatisfactoria(Restaurante):-
    trabajaEn(Restaurante,_),
    forall(trabajaEn(Restaurante,Empleado),not(rata(Empleado,_))).

% -------------------------------------------------------------

/*
2. chef/2: relaciona un empleado con un restaurante si el
empleado trabaja allí y sabe cocinar algún plato.
*/

chef(Empleado,Restaurante):-
    trabajaEn(Restaurante,Empleado),
    cocina(Empleado,_,_).

% -------------------------------------------------------------

/*
3. chefcito/1: se cumple para una rata si vive en el mismo
restaurante donde trabaja linguini.
*/

chefcito(Rata):-
    rata(Rata,Restaurante),
    trabajaEn(Restaurante,linguini).

% -------------------------------------------------------------

/*
4. cocinaBien/2 es verdadero para una persona si su experiencia preparando ese plato es mayor a 7.
Además, remy cocina bien cualquier plato que exista.
*/

cocinaBien(Cocinero,Plato):-
    cocina(Cocinero,Plato,Xp),
    Xp > 7.

cocinaBien(remy,_).

% -------------------------------------------------------------

/*
5. encargadoDe/3: nos dice el encargado de cocinar un plato en un restaurante, que es quien más
experiencia tiene preparándolo en ese lugar.
*/

encargadoDe(Plato,Restaurante,Empleado):-
    trabajaEn(Restaurante,Empleado),
    cocina(Empleado,Plato,_),
    forall(trabajaEn(Restaurante,OtroEmpleado),cocinaPeorUnPlato(OtroEmpleado,Empleado,Plato)).

cocinaPeorUnPlato(OtroEmpleado,Empleado,Plato):-
    cocina(Empleado,Plato,UnaExperiencia),
    cocina(OtroEmpleado,Plato,OtraExperiencia),
    UnaExperiencia > OtraExperiencia.

% -------------------------------------------------------------

plato(ensaladaRusa, entrada([papa, zanahoria, arvejas, huevo, mayonesa])).
plato(bifeDeChorizo, principal(pure, 25)).
plato(frutillasConCrema, postre(265)).

/*
6. saludable/1: un plato es saludable si tiene menos de 75 calorías.
● En las entradas, cada ingrediente suma 15 calorías.
● Los platos principales suman 5 calorías por cada minuto de cocción. Las guarniciones agregan
a la cuenta total: las papasFritas 50 y el puré 20, mientras que la ensalada no aporta calorías.
● De los postres ya conocemos su cantidad de calorías.
Pero además, un postre también puede ser saludable si algún grupo del curso tiene ese nombre de
postre. Usá el predicado grupo/1 como hecho y da un ejemplo con tu nombre de grupo.1
*/

saludable(plato(_,entrada(Ingredientes))):-
    length(Ingredientes, CantidadDeIngredientes),
    Calorias is 15 * CantidadDeIngredientes,
    Calorias < 75.

saludable(plato(_,principal(Guarnicion,MinutosDeCoccion))):-
    caloriasSegunGuarnicion(Guarnicion,CaloriasExtras),
    CaloriasTotales is 5 * MinutosDeCoccion + CaloriasExtras,
    CaloriasTotales < 75.

caloriasSegunGuarnicion(pure,20).
caloriasSegunGuarnicion(papasFritas,50).
caloriasSegunGuarnicion(ensalada,0).

saludable(plato(_,postre(Calorias))):-
    Calorias < 75.

% Se puede extraer logica de estos predicados, pero la resolucion no me quedo muy clara.

% -------------------------------------------------------------

/*
7. criticaPositiva/2: es verdadero para un restaurante si un crítico le escribe una reseña positiva.
Cada crítico maneja su propio criterio, pero todos están de acuerdo en lo mismo: el lugar debe tener
una inspección satisfactoria.
● antonEgo espera, además, que en el lugar sean especialistas preparando ratatouille. Un
restaurante es especialista en aquellos platos que todos sus chefs saben cocinar bien.
● christophe, que el restaurante tenga más de 3 chefs.
● cormillot requiere que todos los platos que saben cocinar los empleados del restaurante sean
saludables y que a ninguna entrada le falte zanahoria.
● gordonRamsay no le da una crítica positiva a ningún restaurante.
*/