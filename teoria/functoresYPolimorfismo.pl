% vende(Articulo,Precio). --> Pueden ser libros o cds
vende(libro(elResplandor,stephenKing,terror),2000).
vende(libro(it,stephenKing,terror),2000).
vende(libro(harryPotter,jkRowling,ficcion),2500).
vende(cd(prisma,pinkFloyd,13,rock),1500).
vende(cd(blood,bob,9,pop),1300).

/*
1 ?- vende(Articulo,Precio).
Articulo = libro(elResplandor, stephenKing, terror),
Precio = 2000 ;
Articulo = libro(harryPotter, jkRowling, ficcion),
Precio = 2500 ;
Articulo = cd(prisma, pinkFloyd, 13, rock),
Precio = 1500 ;
Articulo = cd(blood, bob, 9, pop),
Precio = 1300.

LIBRO/CD NO ES UN PREDICADO, ES UN FUNCTOR!!!!

2 ?- vende(libro(Titulo,stephenKing,_),_). --> Hay que consultarlo asi.
Titulo = elResplandor ;
Titulo = it.

*/

% POLIMORFISMO

% tematico(Autor): Se cumple para un autor si todo lo que se vende ahi es de el.
autor(cd(_,Autor,_,_),Autor):- vende(cd(_,Autor,_,_),_).
autor(libro(_,Autor,_),Autor):- vende(libro(_,Autor,_),_).
                              %Con esta restriccion nuestro predicado "tematico" es completamente inversible.
% Creo el predicado "autor" puedo desentenderme de la FORMA

% Polimorfismo: idea de trabajar con una construccion independientemente de su forma.
% El predicado "autor" es polimorfico, sabe relacionar el autor con un libro o un cd.

tematico(Autor):-
    forall( vende(Articulo,_), autor(Articulo,Autor) ).

% === PRACTICA ===

% 1) libroMasCaro/1 --> Se cumple para un articulo si es el libro de mayor precio.
libroMasCaro(libro(Titulo,Autor,Genero)):-
    vende(libro(Titulo,Autor,Genero),Precio),
    forall(vende(libro(Titulo,Autor,Genero),OtroPrecio),OtroPrecio =< Precio).

% 2) curiosidad/1 --> Se cumple para un articulo si es lo unico que hay a la venta de su autor.
    curiosidad(Articulo):-
        vende(Articulo,_), % con esta linea volvemos el predicado completamente inversible
        autor(Articulo,Autor),
        not((vende(OtroArticulo,_),autor(OtroArticulo,Autor), Articulo \= OtroArticulo)).

% 3) sePrestaAConfusion/1 --> Se cumple para un titulo si pertenece a mas de un articulo. existe algun articulo con el mismo titulo.
titulo(cd(Titulo,_,_,_),Titulo):- vende(cd(Titulo,_,_,_),_).
titulo(libro(Titulo,_,_),Titulo):- vende(libro(Titulo,_,_),_). % Predicado Polimorfico.

sePrestaAConfusion(Titulo):-
    titulo(UnArticulo,Titulo),
    titulo(OtroArticulo,Titulo),
    UnArticulo \= OtroArticulo.

% 4) mixto/1 --> Se cumple para los autores de mas de un tipo de articulo.
mixto(Autor):-
    autor(cd(_,_,_,_),Autor),  
    autor(libro(_,_,_),Autor). % Aca lo estoy tratando de manera no polimorfica.

% 5) Agregar soporte para vender Peliculas con titulo,director y genero
genero(pelicula(Titulo,Genero,Director),Genero):- vende(pelicula(_,Genero,_),_).
titulo(pelicula(Titulo,Genero,Director),Titulo):- vende(pelicula(Titulo,_,_),_).
director(pelicula(Titulo,Genero,Director),Director):- vende(pelicula(_,_,Director),_).
vende(pelicula(it,terror,wallace),1600). % Listo