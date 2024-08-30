% receta(Plato, Duración, Ingredientes)
receta(empanadaDeCarneFrita, 20, [harina, carne, cebolla, picante, aceite]).
receta(empanadaDeCarneAlHorno, 20, [harina, carne, cebolla, picante]).
receta(lomoALaWellington, 125, [lomo, hojaldre, huevo, mostaza]).
receta(pastaTrufada, 40, [spaghetti, crema, trufa]).
receta(souffleDeQueso, 35, [harina, manteca, leche, queso]).
receta(tiramisu, 30, [vainillas, cafe, mascarpone]).
receta(rabas, 20, [calamar, harina, sal]).
receta(parrilladaDelMar, 40, [salmon, langostinos, mejillones]).
receta(sushi, 30, [arroz, salmon, sesamo, algaNori]).
receta(hamburguesa, 15, [carne, pan, cheddar, huevo, panceta, trufa]).
receta(padThai, 40, [fideos, langostinos, vegetales]).
% elabora(Chef, Plato)
elabora(guille, empanadaDeCarneFrita).
elabora(guille, empanadaDeCarneAlHorno).
elabora(vale, rabas).
elabora(vale, tiramisu).
elabora(vale, parrilladaDelMar).
elabora(ale, hamburguesa).
elabora(lu, sushi).
elabora(mar, padThai).
% cocinaEn(Restaurante, Chef)
cocinaEn(pinpun, guille).
cocinaEn(laPececita, vale).
cocinaEn(laParolacha, vale).
cocinaEn(sushiRock, lu).
cocinaEn(olakease, lu).
cocinaEn(guendis, ale).
cocinaEn(cantin, mar).
% tieneEstilo(Restaurante, Estilo)
tieneEstilo(pinpun, bodegon(parqueChas, 6000)).
tieneEstilo(laPececita, bodegon(palermo, 20000)).
tieneEstilo(laParolacha, italiano(15)).
tieneEstilo(sushiRock, oriental(japon)).
tieneEstilo(olakease, oriental(japon)).
tieneEstilo(cantin, oriental(tailandia)).
tieneEstilo(cajaTaco, mexicano([habanero, rocoto])).
tieneEstilo(guendis, comidaRapida(5)).

% Los posibles estilos tienen la siguiente forma:
% italiano(CantidadDePastas)
% oriental(País)
% bodegon(Barrio, PrecioPromedio)
% mexicano(VariedadDeAjies)
% comidaRapida(cantidadDeCombos)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% esCrack/1: un o una chef es crack si trabaja en por lo menos dos restaurantes o cocina pad thai.
 
 esCrack(Chef):-
    elabora(Chef,padThai).

esCrack(Chef):-
    cocinaEn(UnRestaurante,Chef),
    cocinaEn(OtroRestaurante,Chef),
    UnRestaurante \= OtroRestaurante.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% esOtaku/1:  un o una chef es otaku cuando solo trabaja en restaurantes de comida japonesa.  (Y le  tiene  que  gustar  Naruto,  pero  eso no lo vamos a modelar).
esOtaku(Chef):-
    cocinaEn(Restaurante,Chef),
    tieneEstilo(Restaurante,oriental(japon)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% esTop/1:  un plato es top si sólo lo elaboran chefs cracks.
esTop(Plato):-
    receta(Plato,_,_),
    forall(elabora(Chef,Plato),esCrack(Chef)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% esDificil/1: un plato es difícil cuando tiene una duración de más de dos horas o tiene trufa como ingrediente o es un soufflé de queso.

esDificil(souffleDeQueso).

esDificil(Plato):-
    receta(Plato,Duracion,Ingredientes),
    condicionDificultad(Duracion,Ingredientes).

condicionDificultad(Duracion,_):-
    Duracion > 120.

condicionDificultad(_,Ingredientes):-
    member(trufa,Ingredientes).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
seMereceLaMichelin/1:  un  restaurante  se merece  la estrella Michelin cuando tiene un o una chef crack y su estilo de cocina es michelinero. 

Esto sucede cuando es un restaurante:
    a) de comida oriental de Tailandia,
    b) un bodegón de Palermo,
    c) italiano de más de 5 pastas,
    d) mexicano que cocine, por lo menos, con ají habanero y rocoto,
    e) los de comida rápida nunca  serán  michelineros.
 
*/

seMereceLaMichelin(Restaurante):-
    cocinaEn(Restaurante,Chef),
    esCrack(Chef),
    estiloMichelinero(Restaurante).

estiloMichelinero(Restaurante):-
    tieneEstilo(Restaurante,Estilo),
    condicionMichelinero(Estilo).

condicionMichelinero(bodegon(palermo,_)).
condicionMichelinero(italiano(CantidadDePastas)):-CantidadDePastas > 5.
condicionMichelinero(oriental(tailandia)).
condicionMichelinero(mexicano(TipoAjis)):-
    member(habanero,TipoAjis),
    member(rocoto,TipoAjis).

% No hace falta agregar la condicion de comida rapida ya que nunca se cumplira la condicion.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tieneMayorRepertorio/2: según dos restaurantes, se cumple cuando el primero tiene un o una chef que elabora más platos que el o la chef del segundo.
tieneMayorRepertorio(Restaurante1,Restaurante2):-
    cocinaEn(Restaurante1,Chef1),
    cocinaEn(Restaurante2,Chef2),
    cantidadDePlatosDeUnChef(Chef1,CantidadDePlatosChef1),
    cantidadDePlatosDeUnChef(Chef2,CantidadDePlatosChef2),
    CantidadDePlatosChef1 > CantidadDePlatosChef2.

cantidadDePlatosDeUnChef(Chef,CantidadDePlatos):-
    findall(Plato,elabora(Chef,Plato),Platos),
    length(Platos,CantidadDePlatos).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calificacionGastronomica/2: la calificación de un restaurante es 5 veces la cantidad de platos que elabora el o la chef de este restaurante.
calificacionGastronomica(Restaurante,Calificacion):-
    cocinaEn(Restaurante,Chef),
    cantidadDePlatosDeUnChef(Chef,CantidadDePlatos),
    Calificacion is CantidadDePlatos * 5.