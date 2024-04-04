----1. Crea y agrega al entregable las consultas para completar el setup de acuerdo a lo pedido.

CREATE TABLE Usuarios(
id SERIAL PRIMARY KEY,
email VARCHAR(30),
nombre VARCHAR(50),	apellido varchar (50),
	    rol VARCHAR(20) NOT NULL

);
INSERT INTO usuarios (email, nombre, apellido, rol) VALUES
('usuario1@example.com', 'Juan', 'Pérez', 'administrador'), 
('usuario2@example.com', 'María', 'González', 'usuario'),
('usuario3@example.com', 'Carlos', 'Martínez', 'usuario'),
('usuario4@example.com', 'Ana', 'López', 'usuario'),
('usuario5@example.com', 'Pedro', 'Sánchez', 'usuario');
select * from usuarios


CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(100), 
    contenido TEXT,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    destacado BOOLEAN,
    usuario_id BIGINT
);

INSERT INTO posts (titulo, contenido, destacado, usuario_id)
VALUES
    ('Descubriendo nuevos horizontes', '¡Hoy emprendemos un viaje hacia lo desconocido! Exploraremos nuevos lugares, conoceremos personas interesantes y crearemos recuerdos inolvidables. ¡Acompáñanos en esta aventura!', true, 1),
    ('Reflexiones al atardecer', 'El sol se esconde en el horizonte, dejando atrás un día lleno de experiencias y aprendizajes. Es momento de reflexionar sobre lo vivido y planificar el futuro. ¿Qué lecciones has aprendido hoy?', true, 1),
    ('Arte en todas sus formas', 'La creatividad no tiene límites. Hoy exploraremos el mundo del arte en todas sus formas: pintura, música, danza, literatura y más. ¿Cuál es tu forma favorita de expresión artística?', false, 2),
    ('Recetas para el alma', 'Encontrar la felicidad en las pequeñas cosas de la vida es un arte. Compartiré contigo algunas recetas para el alma que te ayudarán a encontrar la alegría en tu día a día. ¡Aprende a saborear la vida!', true, 3),
    ('Conectando con la naturaleza', 'Respira profundamente y siente la brisa en tu rostro. Hoy nos sumergiremos en la naturaleza para reconectar con nuestro entorno y encontrar paz interior. ¿Cuál es tu lugar natural favorito?', false, NULL);
select * from posts


CREATE TABLE comentarios (
    id SERIAL PRIMARY KEY,
    contenido VARCHAR(100), 
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    usuario_id BIGINT, 
    post_id BIGINT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id), 
    FOREIGN KEY (post_id) REFERENCES posts(id)
);

INSERT INTO comentarios (contenido, usuario_id, post_id)
VALUES
    ('¡Gran post! Me encantó la aventura.', 1, 1),
    ('Excelente reflexión. ¡Gracias por compartir!', 2, 1),
    ('Interesante. Me inspiraste a planificar mi próximo viaje.', 3, 1);
	
INSERT INTO comentarios (contenido, usuario_id, post_id)
VALUES
    ('¡Este post es genial! Estoy de acuerdo con tus reflexiones.', 1, 2), 
    ('Gracias por compartir tus pensamientos. ¡Me hiciste reflexionar!', 2, 2); 

---2. Cruza los datos de la tabla usuarios y posts, mostrando las siguientes columnas: 
---nombre y email del usuario junto al título y contenido del post.

select * from comentarios

select u.nombre,
		u.email , 
		p.titulo, 
		p.contenido 
from 
	usuarios u left join posts p on (u.id = p.usuario_id)-- con esto se priorizan para ver todo los usuarios


select 
	u.nombre,
	u.email , 
	p.titulo, 
	p.contenido 
from usuarios u right join posts e on (u.id = p.usuario_id)-- con esto se priorizan para ver todo los comentarios

select
	u.nombre,
	u.email ,
	p.titulo, 
	p.contenido 
from 
	usuarios u inner join posts p on (u.id = p.usuario_id)--- priorizo ver todos los comentarios asociados al usuarios 

--3. Muestra el id, título y contenido de los posts de los administradores.
---a. El administrador puede ser cualquier id.

select 
	p.id, 
	p.titulo, 
	p.contenido 
from 
	usuarios u inner join posts p on (u.id = p.usuario_id) where u.rol ='administrador'

--4. Cuenta la cantidad de posts de cada usuario.
--a. La tabla resultante debe mostrar el id e email del usuario junto con la
--cantidad de posts de cada usuario.

select 
	u.id, 
	u.email,
	count(p.id) as cantidad_post
from usuarios u 
	inner join posts p 
		on (u.id = p.usuario_id)
group by u.id, u.email
		
--5. Muestra el email del usuario que ha creado más posts.
--a. Aquí la tabla resultante tiene un único registro y muestra solo el email.
select 
	tabla_ranking.email 
from
	(
		select 
			u.nombre, 
			u.email,
			count(p.id) as cantidad_post
		from usuarios u 
			inner join posts p 
				on (u.id = p.usuario_id)
		group by u.nombre, u.email
		order by cantidad_post desc
	) as tabla_ranking
limit 1

--6. Muestra la fecha del último post de cada usuario.

SELECT 
	u.nombre, 
	u.email, MAX(p.fecha_creacion) AS fecha_ultimo_post
FROM usuarios u INNER JOIN posts p ON u.id = p.usuario_id
GROUP BY u.nombre, u.email;

--7. Muestra el título y contenido del post (artículo) con más comentarios.
SELECT
	p.titulo,
	p.contenido, COUNT(c.id) AS cantidad_comentarios
FROM posts p INNER JOIN comentarios c ON p.id = c.post_id
GROUP BY p.titulo, p.contenido ORDER BY cantidad_comentarios DESC
LIMIT 1;

--8. Muestra en una tabla el título de cada post, el contenido de cada post y el contenido
--de cada comentario asociado a los posts mostrados, junto con el email del usuario que lo escribió.

SELECT p.titulo, 
       p.contenido, 
       c.contenido, 
       u.email
FROM posts p
LEFT JOIN comentarios c ON p.id = c.post_id
INNER JOIN usuarios u ON c.usuario_id = u.id
ORDER BY p.id, c.id;

--9. Muestra el contenido del último comentario de cada usuario.
SELECT u.email AS email_usuario,
       MAX(c.fecha_creacion) AS fecha_ultimo_comentario,
       c.contenido AS ultimo_comentario
FROM usuarios u
INNER JOIN comentarios c ON u.id = c.usuario_id
GROUP BY u.email, c.contenido;

---10. Muestra los emails de los usuarios que no han escrito ningún comentario.

SELECT u.email
FROM usuarios u
LEFT JOIN comentarios c ON u.id = c.usuario_id
WHERE c.usuario_id IS NULL;

SELECT u.email
FROM usuarios u
LEFT JOIN comentarios c ON u.id = c.usuario_id
GROUP BY u.id, u.email
HAVING COUNT(c.id) = 0;

