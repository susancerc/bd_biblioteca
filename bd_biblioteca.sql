PGDMP                  	    |           bd_biblioteca    15.8    16.4 h    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16398    bd_biblioteca    DATABASE     �   CREATE DATABASE bd_biblioteca WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Spanish_Mexico.1252';
    DROP DATABASE bd_biblioteca;
                postgres    false            �            1255    16602    actualizar_fecha_usuario()    FUNCTION     �   CREATE FUNCTION public.actualizar_fecha_usuario() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.actualizado_usu = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;
 1   DROP FUNCTION public.actualizar_fecha_usuario();
       public          postgres    false            �            1255    16595    actualizar_timestamp()    FUNCTION     �   CREATE FUNCTION public.actualizar_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.actualizado_pres = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;
 -   DROP FUNCTION public.actualizar_timestamp();
       public          postgres    false            �            1255    16589    actualizar_timestamp_autor()    FUNCTION     �   CREATE FUNCTION public.actualizar_timestamp_autor() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.actualizado_autor = CURRENT_TIMESTAMP;  -- Actualiza el timestamp
    RETURN NEW;
END;
$$;
 3   DROP FUNCTION public.actualizar_timestamp_autor();
       public          postgres    false            �            1255    16593     actualizar_timestamp_editorial()    FUNCTION     �   CREATE FUNCTION public.actualizar_timestamp_editorial() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.actualizado_edit = CURRENT_TIMESTAMP;  -- Actualiza el timestamp
    RETURN NEW;
END;
$$;
 7   DROP FUNCTION public.actualizar_timestamp_editorial();
       public          postgres    false            �            1255    16591    actualizar_timestamp_empleado()    FUNCTION     �   CREATE FUNCTION public.actualizar_timestamp_empleado() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.actualizado_emp = CURRENT_TIMESTAMP;  
END;
$$;
 6   DROP FUNCTION public.actualizar_timestamp_empleado();
       public          postgres    false            �            1255    16605    auditoria_usuarios()    FUNCTION     �  CREATE FUNCTION public.auditoria_usuarios() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO auditoria (id_empleado, accion_audi, tabla_modificada_audi, datos_nuevos_audi)
        VALUES (NEW.id_empleado, 'INSERT', 'usuarios', ROW_TO_JSON(NEW)::TEXT);
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO auditoria (id_empleado, accion_audi, tabla_modificada_audi, datos_anterior_audi, datos_nuevos_audi)
        VALUES (NEW.id_empleado, 'UPDATE', 'usuarios', ROW_TO_JSON(OLD)::TEXT, ROW_TO_JSON(NEW)::TEXT);
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO auditoria (id_empleado, accion_audi, tabla_modificada_audi, datos_anterior_audi)
        VALUES (OLD.id_empleado, 'DELETE', 'usuarios', ROW_TO_JSON(OLD)::TEXT);
        RETURN OLD;
    END IF;

    RETURN NULL;  -- Esto es para el caso de que no se cumpla ninguna condición.
END;
$$;
 +   DROP FUNCTION public.auditoria_usuarios();
       public          postgres    false            �            1259    16539 	   auditoria    TABLE     n  CREATE TABLE public.auditoria (
    id_auditoria integer NOT NULL,
    id_empleado integer,
    accion_audi character varying(100) NOT NULL,
    tabla_modificada_audi character varying(100) NOT NULL,
    fecha_audi timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    descripcion_audi text,
    datos_anterior_audi text,
    datos_nuevos_audi text
);
    DROP TABLE public.auditoria;
       public         heap    postgres    false            �            1259    16538    auditoria_id_auditoria_seq    SEQUENCE     �   CREATE SEQUENCE public.auditoria_id_auditoria_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.auditoria_id_auditoria_seq;
       public          postgres    false    230            �           0    0    auditoria_id_auditoria_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.auditoria_id_auditoria_seq OWNED BY public.auditoria.id_auditoria;
          public          postgres    false    229            �            1259    16445    autores    TABLE     �  CREATE TABLE public.autores (
    id_autor integer NOT NULL,
    nombre_autor character varying(100) NOT NULL,
    apellidop_autor character varying(100) NOT NULL,
    apelidom_autor character varying(100) NOT NULL,
    nacionalidad_autor character varying(100),
    fechanac_autor date,
    creado_autor timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    actualizado_autor timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE public.autores;
       public         heap    postgres    false            �            1259    16444    autores_id_autor_seq    SEQUENCE     �   CREATE SEQUENCE public.autores_id_autor_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.autores_id_autor_seq;
       public          postgres    false    219            �           0    0    autores_id_autor_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.autores_id_autor_seq OWNED BY public.autores.id_autor;
          public          postgres    false    218            �            1259    16478 
   categorias    TABLE     �   CREATE TABLE public.categorias (
    id_categoria integer NOT NULL,
    nombre_categoria character varying(100) NOT NULL,
    descripcion_categoria text
);
    DROP TABLE public.categorias;
       public         heap    postgres    false            �            1259    16477    categorias_id_categoria_seq    SEQUENCE     �   CREATE SEQUENCE public.categorias_id_categoria_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.categorias_id_categoria_seq;
       public          postgres    false    223            �           0    0    categorias_id_categoria_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.categorias_id_categoria_seq OWNED BY public.categorias.id_categoria;
          public          postgres    false    222            �            1259    16418    editoriales    TABLE     �  CREATE TABLE public.editoriales (
    id_editorial integer NOT NULL,
    nombre_edit character varying(100) NOT NULL,
    telefono_edit character varying(15),
    email_edit character varying(100),
    direccion_edit character varying(255),
    pais_edit character varying(100),
    creado_edit timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    actualizado_edit timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE public.editoriales;
       public         heap    postgres    false            �            1259    16417    editoriales_id_editorial_seq    SEQUENCE     �   CREATE SEQUENCE public.editoriales_id_editorial_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.editoriales_id_editorial_seq;
       public          postgres    false    217            �           0    0    editoriales_id_editorial_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public.editoriales_id_editorial_seq OWNED BY public.editoriales.id_editorial;
          public          postgres    false    216            �            1259    16504 	   empleados    TABLE     �  CREATE TABLE public.empleados (
    id_empleado integer NOT NULL,
    nombre_emp character varying(100) NOT NULL,
    apellidop_emp character varying(100) NOT NULL,
    apelidom_emp character varying(100) NOT NULL,
    email_emp character varying(200),
    telefono_emp character varying(15),
    direccion_emp character varying(200),
    cargo_emp character varying(50) NOT NULL,
    ciudad_emp character varying(100),
    estado_emp character varying(100),
    codigo_postal character varying(10),
    creado_emp timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    actualizado_emp timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT empleados_telefono_emp_check CHECK (((telefono_emp)::text ~ '^[0-9]{10,15}$'::text))
);
    DROP TABLE public.empleados;
       public         heap    postgres    false            �            1259    16503    empleados_id_empleado_seq    SEQUENCE     �   CREATE SEQUENCE public.empleados_id_empleado_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.empleados_id_empleado_seq;
       public          postgres    false    226            �           0    0    empleados_id_empleado_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.empleados_id_empleado_seq OWNED BY public.empleados.id_empleado;
          public          postgres    false    225            �            1259    16488    libro_categoria    TABLE     j   CREATE TABLE public.libro_categoria (
    id_libro integer NOT NULL,
    id_categoria integer NOT NULL
);
 #   DROP TABLE public.libro_categoria;
       public         heap    postgres    false            �            1259    16454    libros    TABLE     �  CREATE TABLE public.libros (
    id_libro integer NOT NULL,
    titulo_libro character varying(255) NOT NULL,
    isbn_libro character varying(20) NOT NULL,
    id_autor integer,
    id_editorial integer,
    anio_publicacion_libro integer,
    cantidad_libro integer DEFAULT 1 NOT NULL,
    creado_libro timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    actualizado_libro timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT libros_anio_publicacion_libro_check CHECK (((anio_publicacion_libro > 0) AND ((anio_publicacion_libro)::numeric <= EXTRACT(year FROM CURRENT_DATE)))),
    CONSTRAINT libros_cantidad_libro_check CHECK ((cantidad_libro >= 0))
);
    DROP TABLE public.libros;
       public         heap    postgres    false            �            1259    16453    libros_id_libro_seq    SEQUENCE     �   CREATE SEQUENCE public.libros_id_libro_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.libros_id_libro_seq;
       public          postgres    false    221            �           0    0    libros_id_libro_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.libros_id_libro_seq OWNED BY public.libros.id_libro;
          public          postgres    false    220            �            1259    16575    multas    TABLE     F  CREATE TABLE public.multas (
    id_multa integer NOT NULL,
    id_prestamo integer,
    cantidad_multa numeric(10,2) NOT NULL,
    pagada_multa boolean DEFAULT false,
    fecha_multa timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT multas_cantidad_multa_check CHECK ((cantidad_multa >= (0)::numeric))
);
    DROP TABLE public.multas;
       public         heap    postgres    false            �            1259    16574    multas_id_multa_seq    SEQUENCE     �   CREATE SEQUENCE public.multas_id_multa_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.multas_id_multa_seq;
       public          postgres    false    234            �           0    0    multas_id_multa_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.multas_id_multa_seq OWNED BY public.multas.id_multa;
          public          postgres    false    233            �            1259    16518 	   prestamos    TABLE     �  CREATE TABLE public.prestamos (
    id_prestamo integer NOT NULL,
    fecha_pres date NOT NULL,
    fecha_vencimiento_pres date NOT NULL,
    fecha_devolucion_pres date,
    estado_pre character varying(20) NOT NULL,
    creado_pres timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    actualizado_pres timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    id_usuario integer,
    id_libro integer,
    CONSTRAINT prestamos_check CHECK ((fecha_vencimiento_pres > fecha_pres)),
    CONSTRAINT prestamos_estado_pre_check CHECK (((estado_pre)::text = ANY ((ARRAY['Pendiente'::character varying, 'Completado'::character varying, 'Cancelado'::character varying])::text[])))
);
    DROP TABLE public.prestamos;
       public         heap    postgres    false            �            1259    16517    prestamos_id_prestamo_seq    SEQUENCE     �   CREATE SEQUENCE public.prestamos_id_prestamo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.prestamos_id_prestamo_seq;
       public          postgres    false    228            �           0    0    prestamos_id_prestamo_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.prestamos_id_prestamo_seq OWNED BY public.prestamos.id_prestamo;
          public          postgres    false    227            �            1259    16554    reservas    TABLE     �  CREATE TABLE public.reservas (
    id_reserva integer NOT NULL,
    id_usuario integer,
    id_libro integer,
    fecha_reserva timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecha_vencimiento_reserva timestamp without time zone,
    estado_reserva character varying(50) DEFAULT 'Pendiente'::character varying,
    CONSTRAINT reservas_check CHECK ((fecha_vencimiento_reserva > fecha_reserva)),
    CONSTRAINT reservas_estado_reserva_check CHECK (((estado_reserva)::text = ANY ((ARRAY['Pendiente'::character varying, 'Recogido'::character varying, 'Cancelado'::character varying, 'Vencido'::character varying, 'Completado'::character varying, 'En Espera'::character varying, 'En Proceso'::character varying])::text[])))
);
    DROP TABLE public.reservas;
       public         heap    postgres    false            �            1259    16553    reservas_id_reserva_seq    SEQUENCE     �   CREATE SEQUENCE public.reservas_id_reserva_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.reservas_id_reserva_seq;
       public          postgres    false    232            �           0    0    reservas_id_reserva_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.reservas_id_reserva_seq OWNED BY public.reservas.id_reserva;
          public          postgres    false    231            �            1259    16401    usuarios    TABLE       CREATE TABLE public.usuarios (
    id_usuario integer NOT NULL,
    nombre_usuario character varying(100) NOT NULL,
    apellidop_usu character varying(100) NOT NULL,
    apellidom_usu character varying(100),
    numtelefono_usu character varying(15),
    email_usu character varying(255) NOT NULL,
    estado_usu character varying(50) DEFAULT 'activo'::character varying NOT NULL,
    creado_usu timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    actualizado_usu timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE public.usuarios;
       public         heap    postgres    false            �            1259    16400    usuarios_id_usuario_seq    SEQUENCE     �   CREATE SEQUENCE public.usuarios_id_usuario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.usuarios_id_usuario_seq;
       public          postgres    false    215            �           0    0    usuarios_id_usuario_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.usuarios_id_usuario_seq OWNED BY public.usuarios.id_usuario;
          public          postgres    false    214            �           2604    16542    auditoria id_auditoria    DEFAULT     �   ALTER TABLE ONLY public.auditoria ALTER COLUMN id_auditoria SET DEFAULT nextval('public.auditoria_id_auditoria_seq'::regclass);
 E   ALTER TABLE public.auditoria ALTER COLUMN id_auditoria DROP DEFAULT;
       public          postgres    false    230    229    230            �           2604    16448    autores id_autor    DEFAULT     t   ALTER TABLE ONLY public.autores ALTER COLUMN id_autor SET DEFAULT nextval('public.autores_id_autor_seq'::regclass);
 ?   ALTER TABLE public.autores ALTER COLUMN id_autor DROP DEFAULT;
       public          postgres    false    218    219    219            �           2604    16481    categorias id_categoria    DEFAULT     �   ALTER TABLE ONLY public.categorias ALTER COLUMN id_categoria SET DEFAULT nextval('public.categorias_id_categoria_seq'::regclass);
 F   ALTER TABLE public.categorias ALTER COLUMN id_categoria DROP DEFAULT;
       public          postgres    false    222    223    223            �           2604    16421    editoriales id_editorial    DEFAULT     �   ALTER TABLE ONLY public.editoriales ALTER COLUMN id_editorial SET DEFAULT nextval('public.editoriales_id_editorial_seq'::regclass);
 G   ALTER TABLE public.editoriales ALTER COLUMN id_editorial DROP DEFAULT;
       public          postgres    false    217    216    217            �           2604    16507    empleados id_empleado    DEFAULT     ~   ALTER TABLE ONLY public.empleados ALTER COLUMN id_empleado SET DEFAULT nextval('public.empleados_id_empleado_seq'::regclass);
 D   ALTER TABLE public.empleados ALTER COLUMN id_empleado DROP DEFAULT;
       public          postgres    false    226    225    226            �           2604    16457    libros id_libro    DEFAULT     r   ALTER TABLE ONLY public.libros ALTER COLUMN id_libro SET DEFAULT nextval('public.libros_id_libro_seq'::regclass);
 >   ALTER TABLE public.libros ALTER COLUMN id_libro DROP DEFAULT;
       public          postgres    false    220    221    221            �           2604    16578    multas id_multa    DEFAULT     r   ALTER TABLE ONLY public.multas ALTER COLUMN id_multa SET DEFAULT nextval('public.multas_id_multa_seq'::regclass);
 >   ALTER TABLE public.multas ALTER COLUMN id_multa DROP DEFAULT;
       public          postgres    false    234    233    234            �           2604    16521    prestamos id_prestamo    DEFAULT     ~   ALTER TABLE ONLY public.prestamos ALTER COLUMN id_prestamo SET DEFAULT nextval('public.prestamos_id_prestamo_seq'::regclass);
 D   ALTER TABLE public.prestamos ALTER COLUMN id_prestamo DROP DEFAULT;
       public          postgres    false    227    228    228            �           2604    16557    reservas id_reserva    DEFAULT     z   ALTER TABLE ONLY public.reservas ALTER COLUMN id_reserva SET DEFAULT nextval('public.reservas_id_reserva_seq'::regclass);
 B   ALTER TABLE public.reservas ALTER COLUMN id_reserva DROP DEFAULT;
       public          postgres    false    232    231    232            �           2604    16404    usuarios id_usuario    DEFAULT     z   ALTER TABLE ONLY public.usuarios ALTER COLUMN id_usuario SET DEFAULT nextval('public.usuarios_id_usuario_seq'::regclass);
 B   ALTER TABLE public.usuarios ALTER COLUMN id_usuario DROP DEFAULT;
       public          postgres    false    214    215    215            �          0    16539 	   auditoria 
   TABLE DATA           �   COPY public.auditoria (id_auditoria, id_empleado, accion_audi, tabla_modificada_audi, fecha_audi, descripcion_audi, datos_anterior_audi, datos_nuevos_audi) FROM stdin;
    public          postgres    false    230   $�       �          0    16445    autores 
   TABLE DATA           �   COPY public.autores (id_autor, nombre_autor, apellidop_autor, apelidom_autor, nacionalidad_autor, fechanac_autor, creado_autor, actualizado_autor) FROM stdin;
    public          postgres    false    219   ̒       �          0    16478 
   categorias 
   TABLE DATA           [   COPY public.categorias (id_categoria, nombre_categoria, descripcion_categoria) FROM stdin;
    public          postgres    false    223   ��       �          0    16418    editoriales 
   TABLE DATA           �   COPY public.editoriales (id_editorial, nombre_edit, telefono_edit, email_edit, direccion_edit, pais_edit, creado_edit, actualizado_edit) FROM stdin;
    public          postgres    false    217   ��       �          0    16504 	   empleados 
   TABLE DATA           �   COPY public.empleados (id_empleado, nombre_emp, apellidop_emp, apelidom_emp, email_emp, telefono_emp, direccion_emp, cargo_emp, ciudad_emp, estado_emp, codigo_postal, creado_emp, actualizado_emp) FROM stdin;
    public          postgres    false    226   ֢       �          0    16488    libro_categoria 
   TABLE DATA           A   COPY public.libro_categoria (id_libro, id_categoria) FROM stdin;
    public          postgres    false    224   J�       �          0    16454    libros 
   TABLE DATA           �   COPY public.libros (id_libro, titulo_libro, isbn_libro, id_autor, id_editorial, anio_publicacion_libro, cantidad_libro, creado_libro, actualizado_libro) FROM stdin;
    public          postgres    false    221   ��       �          0    16575    multas 
   TABLE DATA           b   COPY public.multas (id_multa, id_prestamo, cantidad_multa, pagada_multa, fecha_multa) FROM stdin;
    public          postgres    false    234   Щ       �          0    16518 	   prestamos 
   TABLE DATA           �   COPY public.prestamos (id_prestamo, fecha_pres, fecha_vencimiento_pres, fecha_devolucion_pres, estado_pre, creado_pres, actualizado_pres, id_usuario, id_libro) FROM stdin;
    public          postgres    false    228   ?�       �          0    16554    reservas 
   TABLE DATA           ~   COPY public.reservas (id_reserva, id_usuario, id_libro, fecha_reserva, fecha_vencimiento_reserva, estado_reserva) FROM stdin;
    public          postgres    false    232   ��       �          0    16401    usuarios 
   TABLE DATA           �   COPY public.usuarios (id_usuario, nombre_usuario, apellidop_usu, apellidom_usu, numtelefono_usu, email_usu, estado_usu, creado_usu, actualizado_usu) FROM stdin;
    public          postgres    false    215   E�       �           0    0    auditoria_id_auditoria_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.auditoria_id_auditoria_seq', 1, false);
          public          postgres    false    229            �           0    0    autores_id_autor_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.autores_id_autor_seq', 1, false);
          public          postgres    false    218            �           0    0    categorias_id_categoria_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.categorias_id_categoria_seq', 1, false);
          public          postgres    false    222            �           0    0    editoriales_id_editorial_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.editoriales_id_editorial_seq', 1, false);
          public          postgres    false    216            �           0    0    empleados_id_empleado_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.empleados_id_empleado_seq', 4, true);
          public          postgres    false    225            �           0    0    libros_id_libro_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.libros_id_libro_seq', 1, false);
          public          postgres    false    220            �           0    0    multas_id_multa_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.multas_id_multa_seq', 8, true);
          public          postgres    false    233            �           0    0    prestamos_id_prestamo_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.prestamos_id_prestamo_seq', 1, false);
          public          postgres    false    227            �           0    0    reservas_id_reserva_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.reservas_id_reserva_seq', 8, true);
          public          postgres    false    231            �           0    0    usuarios_id_usuario_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.usuarios_id_usuario_seq', 147, true);
          public          postgres    false    214            �           2606    16547    auditoria auditoria_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.auditoria
    ADD CONSTRAINT auditoria_pkey PRIMARY KEY (id_auditoria);
 B   ALTER TABLE ONLY public.auditoria DROP CONSTRAINT auditoria_pkey;
       public            postgres    false    230            �           2606    16452    autores autores_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.autores
    ADD CONSTRAINT autores_pkey PRIMARY KEY (id_autor);
 >   ALTER TABLE ONLY public.autores DROP CONSTRAINT autores_pkey;
       public            postgres    false    219            �           2606    16487 *   categorias categorias_nombre_categoria_key 
   CONSTRAINT     q   ALTER TABLE ONLY public.categorias
    ADD CONSTRAINT categorias_nombre_categoria_key UNIQUE (nombre_categoria);
 T   ALTER TABLE ONLY public.categorias DROP CONSTRAINT categorias_nombre_categoria_key;
       public            postgres    false    223            �           2606    16485    categorias categorias_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.categorias
    ADD CONSTRAINT categorias_pkey PRIMARY KEY (id_categoria);
 D   ALTER TABLE ONLY public.categorias DROP CONSTRAINT categorias_pkey;
       public            postgres    false    223            �           2606    16429 &   editoriales editoriales_email_edit_key 
   CONSTRAINT     g   ALTER TABLE ONLY public.editoriales
    ADD CONSTRAINT editoriales_email_edit_key UNIQUE (email_edit);
 P   ALTER TABLE ONLY public.editoriales DROP CONSTRAINT editoriales_email_edit_key;
       public            postgres    false    217            �           2606    16427    editoriales editoriales_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.editoriales
    ADD CONSTRAINT editoriales_pkey PRIMARY KEY (id_editorial);
 F   ALTER TABLE ONLY public.editoriales DROP CONSTRAINT editoriales_pkey;
       public            postgres    false    217            �           2606    16516 !   empleados empleados_email_emp_key 
   CONSTRAINT     a   ALTER TABLE ONLY public.empleados
    ADD CONSTRAINT empleados_email_emp_key UNIQUE (email_emp);
 K   ALTER TABLE ONLY public.empleados DROP CONSTRAINT empleados_email_emp_key;
       public            postgres    false    226            �           2606    16514    empleados empleados_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.empleados
    ADD CONSTRAINT empleados_pkey PRIMARY KEY (id_empleado);
 B   ALTER TABLE ONLY public.empleados DROP CONSTRAINT empleados_pkey;
       public            postgres    false    226            �           2606    16492 $   libro_categoria libro_categoria_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.libro_categoria
    ADD CONSTRAINT libro_categoria_pkey PRIMARY KEY (id_libro, id_categoria);
 N   ALTER TABLE ONLY public.libro_categoria DROP CONSTRAINT libro_categoria_pkey;
       public            postgres    false    224    224            �           2606    16466    libros libros_isbn_libro_key 
   CONSTRAINT     ]   ALTER TABLE ONLY public.libros
    ADD CONSTRAINT libros_isbn_libro_key UNIQUE (isbn_libro);
 F   ALTER TABLE ONLY public.libros DROP CONSTRAINT libros_isbn_libro_key;
       public            postgres    false    221            �           2606    16464    libros libros_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.libros
    ADD CONSTRAINT libros_pkey PRIMARY KEY (id_libro);
 <   ALTER TABLE ONLY public.libros DROP CONSTRAINT libros_pkey;
       public            postgres    false    221            �           2606    16583    multas multas_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.multas
    ADD CONSTRAINT multas_pkey PRIMARY KEY (id_multa);
 <   ALTER TABLE ONLY public.multas DROP CONSTRAINT multas_pkey;
       public            postgres    false    234            �           2606    16527    prestamos prestamos_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.prestamos
    ADD CONSTRAINT prestamos_pkey PRIMARY KEY (id_prestamo);
 B   ALTER TABLE ONLY public.prestamos DROP CONSTRAINT prestamos_pkey;
       public            postgres    false    228            �           2606    16563    reservas reservas_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.reservas
    ADD CONSTRAINT reservas_pkey PRIMARY KEY (id_reserva);
 @   ALTER TABLE ONLY public.reservas DROP CONSTRAINT reservas_pkey;
       public            postgres    false    232            �           2606    16411    usuarios usuarios_email_usu_key 
   CONSTRAINT     _   ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_email_usu_key UNIQUE (email_usu);
 I   ALTER TABLE ONLY public.usuarios DROP CONSTRAINT usuarios_email_usu_key;
       public            postgres    false    215            �           2606    16409    usuarios usuarios_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id_usuario);
 @   ALTER TABLE ONLY public.usuarios DROP CONSTRAINT usuarios_pkey;
       public            postgres    false    215            �           2620    16603    usuarios actualizar_usuario    TRIGGER     �   CREATE TRIGGER actualizar_usuario BEFORE UPDATE ON public.usuarios FOR EACH ROW EXECUTE FUNCTION public.actualizar_fecha_usuario();
 4   DROP TRIGGER actualizar_usuario ON public.usuarios;
       public          postgres    false    215    238            �           2620    16590    autores autores_actualizado    TRIGGER     �   CREATE TRIGGER autores_actualizado BEFORE UPDATE ON public.autores FOR EACH ROW EXECUTE FUNCTION public.actualizar_timestamp_autor();
 4   DROP TRIGGER autores_actualizado ON public.autores;
       public          postgres    false    235    219            �           2620    16594 #   editoriales editoriales_actualizado    TRIGGER     �   CREATE TRIGGER editoriales_actualizado BEFORE UPDATE ON public.editoriales FOR EACH ROW EXECUTE FUNCTION public.actualizar_timestamp_editorial();
 <   DROP TRIGGER editoriales_actualizado ON public.editoriales;
       public          postgres    false    237    217            �           2620    16592    empleados empleados_actualizado    TRIGGER     �   CREATE TRIGGER empleados_actualizado BEFORE UPDATE ON public.empleados FOR EACH ROW EXECUTE FUNCTION public.actualizar_timestamp_empleado();
 8   DROP TRIGGER empleados_actualizado ON public.empleados;
       public          postgres    false    226    236            �           2620    16596    libros libros_actualizado    TRIGGER     ~   CREATE TRIGGER libros_actualizado BEFORE UPDATE ON public.libros FOR EACH ROW EXECUTE FUNCTION public.actualizar_timestamp();
 2   DROP TRIGGER libros_actualizado ON public.libros;
       public          postgres    false    221    240            �           2620    16607    prestamos prestamos_actualizado    TRIGGER     �   CREATE TRIGGER prestamos_actualizado BEFORE UPDATE ON public.prestamos FOR EACH ROW EXECUTE FUNCTION public.actualizar_timestamp();
 8   DROP TRIGGER prestamos_actualizado ON public.prestamos;
       public          postgres    false    228    240            �           2606    16548 $   auditoria auditoria_id_empleado_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.auditoria
    ADD CONSTRAINT auditoria_id_empleado_fkey FOREIGN KEY (id_empleado) REFERENCES public.empleados(id_empleado) ON DELETE CASCADE;
 N   ALTER TABLE ONLY public.auditoria DROP CONSTRAINT auditoria_id_empleado_fkey;
       public          postgres    false    3288    230    226            �           2606    16498 1   libro_categoria libro_categoria_id_categoria_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.libro_categoria
    ADD CONSTRAINT libro_categoria_id_categoria_fkey FOREIGN KEY (id_categoria) REFERENCES public.categorias(id_categoria) ON DELETE CASCADE;
 [   ALTER TABLE ONLY public.libro_categoria DROP CONSTRAINT libro_categoria_id_categoria_fkey;
       public          postgres    false    224    223    3282            �           2606    16493 -   libro_categoria libro_categoria_id_libro_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.libro_categoria
    ADD CONSTRAINT libro_categoria_id_libro_fkey FOREIGN KEY (id_libro) REFERENCES public.libros(id_libro) ON DELETE CASCADE;
 W   ALTER TABLE ONLY public.libro_categoria DROP CONSTRAINT libro_categoria_id_libro_fkey;
       public          postgres    false    221    3278    224            �           2606    16467    libros libros_id_autor_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.libros
    ADD CONSTRAINT libros_id_autor_fkey FOREIGN KEY (id_autor) REFERENCES public.autores(id_autor) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.libros DROP CONSTRAINT libros_id_autor_fkey;
       public          postgres    false    219    221    3274            �           2606    16472    libros libros_id_editorial_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.libros
    ADD CONSTRAINT libros_id_editorial_fkey FOREIGN KEY (id_editorial) REFERENCES public.editoriales(id_editorial) ON DELETE CASCADE;
 I   ALTER TABLE ONLY public.libros DROP CONSTRAINT libros_id_editorial_fkey;
       public          postgres    false    3272    217    221            �           2606    16584    multas multas_id_prestamo_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.multas
    ADD CONSTRAINT multas_id_prestamo_fkey FOREIGN KEY (id_prestamo) REFERENCES public.prestamos(id_prestamo) ON DELETE CASCADE;
 H   ALTER TABLE ONLY public.multas DROP CONSTRAINT multas_id_prestamo_fkey;
       public          postgres    false    3290    228    234            �           2606    16533 !   prestamos prestamos_id_libro_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.prestamos
    ADD CONSTRAINT prestamos_id_libro_fkey FOREIGN KEY (id_libro) REFERENCES public.libros(id_libro) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.prestamos DROP CONSTRAINT prestamos_id_libro_fkey;
       public          postgres    false    228    221    3278            �           2606    16528 #   prestamos prestamos_id_usuario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.prestamos
    ADD CONSTRAINT prestamos_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id_usuario) ON DELETE CASCADE;
 M   ALTER TABLE ONLY public.prestamos DROP CONSTRAINT prestamos_id_usuario_fkey;
       public          postgres    false    228    215    3268            �           2606    16569    reservas reservas_id_libro_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.reservas
    ADD CONSTRAINT reservas_id_libro_fkey FOREIGN KEY (id_libro) REFERENCES public.libros(id_libro) ON DELETE CASCADE;
 I   ALTER TABLE ONLY public.reservas DROP CONSTRAINT reservas_id_libro_fkey;
       public          postgres    false    221    232    3278            �           2606    16564 !   reservas reservas_id_usuario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.reservas
    ADD CONSTRAINT reservas_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id_usuario) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.reservas DROP CONSTRAINT reservas_id_usuario_fkey;
       public          postgres    false    232    3268    215            �   �   x�-���0E��+��`�F�����!/ZӴ	������1Ÿ��sQ�86���	k��O"SY��J2,4*]��¼�Q���h0��y��ˀ����i���g��k�{�h>0��5��6P��G��E�+��8�<�K*�� P!2�      �   �  x��Y�n�H<���?��o��I��ĐCN��b/#q"�f�q��v�[>�Gr0r�l�G/�r�$�P7�UU���_)�Ͳ��٬}0��a�t�����ς��^�/����S/x��o��MQ���O'�P����e.�Ti؝�J�J��`�/p��7R�nV�"�gW�4ۧz� u��KmVx�FVlL+6�kYK2�f=|9���e���m��a�{'���k�������Z��M�A^�y��`Ʃ�x����������bȦ�1��U��F�o���Ǟ��x� �]��/�fQۜ���G$�6���wm��}Z�|�Z\���/u��� t͏�Ҽd�F}E��͒�?�y���ߵ�(�L��36f�m�Ϫ;�>iq4��3�[;�0r��1�fɻN�����]��l�t`�-"��,t�gALuv�?���˪6��s}l�4�PS7���Q�E�X�w��`jT���6|��'�J�S��`�\�	�2B?���u�M)�3�*5>��*��r��@X���X�U�h�(��m�4)g�Ev5�h���v�k�C�0� <W��36'v��Zj�{��ا(�Е�0�av��5�\��!tE���!�\�yŝfs^�?�s�&��h\��,o��)KJ�S�`��b�U��-{[PwOٞ�Ǣ�Եd�����]/����<Qp��!be��F��g����+���/�*�6n����.{tz���s��3�TWr^��o��
mz�b��w���权�[B��-��i.NGUEb��
��>����~��m)嚘q,	�y�M_hY�E��
�oοr�0o0~��M�����錶��B?�ͨ�Qͮ�AM��[e��I-gz�������u4���^0T���Ԅk�5RΚ%�ĤR)�lA�:u-M�4��@�A���ێ�6X��%�wE�0b�¬d-g����nq�&��U��4Vg�����&$A�Bp�^��2�_�M�;]�riY!�
���=g�_����%���(=4���_SQ�������0-q`s�
-a�/���]��	����;.��]�2�.�(�W�-�3B�+�rϹ��~�oX��׼�@$�-�.
��֤��葡c�����h˂�΍�����(W��U��R�hx-
�j����d�9S�r�r* Rv�}�D�EG�Pbv-՚
�i��Ѫ���7w�:q??$lN��0��JI�}妧�ȷ�����4��\��i)���GL���(�S�\�Q�1���U�u��FƮ��.���C�>V$U?��fә�$�:\^�Y!�)OW��4g5:�2v�M�**�D�=�wy1t��w�:xڬt��C�)���f7�^�(`��W�(��!��Nd�=��D���n�ѫ�tqŽ�d������;���3��;+�'v$�q?vB:���z�j$i7�c|��+�J�{��4;�u�_S���_���vy٭�J��u�0�
Jg��C�i�"$BL�'�ȝd�lw��Bw�M%^�O�	ܙ%��}I�����U7�v�UF$��;�۴Or����_�న�qM;�"<�Ar�IL�}$����~��`WvL����O^,)F����{�gep��\�aЯ��@�ֆ���O� ��p�dװg������qx�`;Ov2�v� B���_$)�w)��N��@M��AΫ�)�G��'�?ƊW��a_��������999�?]�f      �   �  x�m��r�@���S��?%d��&5���bvWfw�I�6WRP������>nn�dK?}���z�˯�>�f.�J��OB�RUI�H�DI�
i����H#�5q��J�=s�6K`w�9�WKRH (c��yj�DSb���f�N}U��w��g���dwiq��G�?��n�R�)�i�M�=�m�1����{��GN�a�BU"� e�������h.��{�VF�2�;h��!	g��'��d�u� ۰,� �0,0�*m�������f�9Y�G݀#�L4s@�ׄS0��I�{AL߽v7c%���\t�����;���h�S���7�=gN�Q�z,��Sܰ=�jO_t�d�y����^ߺ�j�̻v�<�m�4�-�8��	I�YQҖ`5������s���Gu[[[�'�3.�o��
��K�u��S$      �   >  x��YMo7=�O=��~�#�J�k���r�4�٥e"��J�*N�MNE9�	�c~�4r�l���;��y�͛7t�W���Ӛ,j*XK�,'I�fY�G�--[���OK�D3Z׌\(*ț�WzL��1��J�*:�k���Fi��'I_$N�%�gEz�"K�:J���rEE%r);͢<O�� gqG\� wL�S��E�����n ��#W�1y!E����������E����:�hT�I�giR�#���1f�a�&JfR)�D�4)��L;&�&n M�
B\<6cy������*7�\���ӻ�zs�I�cb��\�I��bd��m�(9�������(�$��qꦴU;m�v���l���mE�C 7��~�|��/e���8��h"�J��e+��,_>9a�)�fF�bʾR&UII:C��*Y-!�OK�0��j��L�5:JR�/3��[.]��.�kI����1yٱ%�K����RYn�GEם��c�&N 	��,�2��G�IҌ�5I���36�Tr)�q&hmVzcQ� ^C7��u�n�В�Y z'q���'�,o;�2%Y�T	p���(��'\��,&��#򆴷�L��+t�
&	��W%�B����P�]ڤ���\��
�z�)bR�����[K��;���[�ȉn4
�V�%�7��$ԐI2D��Eҗq��x��L�B�l
I�K��O.A�� �)A�>�B�Q)K���J�ҵ2D;.92��d�.�P˯�F�]ɷ����i v�*-�w6u;�`#6q��,[�BZ�d�4�9��L1��-�����Læ_;������8�F��tb�xN9<�=5��q�ͪI2
8ْq4�~UeW[C����a���CSr{��l�T3�1h��S��Õƨ�g�/-���GEm w�h�����ޯ�g����na�K��Nh]�w&����6{���39Z0x9ȣ"�P�RD�%_A	߾}��"�����������q��O3��T`务7N�z�0�-4x�3)0A
8J���d >�+�n�D`�d�?:c9��k�pD�2i���'�7L���f������*��X��W�{׀#�'��Ԍ�tx���dP�,�f�Y��ZI\K<P�������5i���hC�@,��ם`�L�`��Myk������u �0N�P�T�u��v�ӽ��E/�}��/S��H���t�gl�ބ;�D&܄���`)B�:���^�G�|3�������~!y(��4G��}�R�ˀ�>�0>Qp��P�NOJ����ط���jw1����0�5�nlV��~m��o9k�[�T��)�He�ĂU�7�U�n�C�v��o��L�����j|n�׹!�W6v����6�9�c�`Ϣ���6�м3wY`�I��Xt��\��hA�r��Xkc�&��35ժͦ��^	�w�맂��{�X�9��3}��W����5252��gL�U�j���r�V�۝s,��|�'�w~(X{诮lH�C�_KB��9��Cg���BlB�E�²P���/J�Q��cM>�ߖ��_��%���/���Ɇ���R����`1�ݟei��;�2%���D$y�2�.�2�n�m�z-^����9 ���(��y�_{����/<v�@��/=�;��o����䃃;F����������f0%��W�,�ZH,�s.�q�	�/dӇp�ю�j��FG���c����;���A�v;�[�'�G(�α^_��.yc� $.�)} �H�)��*�d3���,�xa�̻k�Pጛ���~�鴻�ZЖ�+�s]���:��}�i�8=::����      �   d  x����n�0���S��*I[
��U�$Į�XMF3�	Ji��8��bsc�|��K�?�椰@^��ڒ�j��qXyX5�M\��d�H�l��'�c}��"���3�j����H!mu�� �'��$H:��㈲�u�q�L���aP&�<��<�0�'�)d�V�<+o������f�[�>Z\�A:��,M'E���@����(H�ݰ�ΔG&u"M��IX9�{��v�l��,U�I^C�B�? ~��h���z偢5'��2)Z��*�(�݉��Ƶd1|��K'�i�aZ�x�'<'�?<ң���K��V9��CJ-Y�J�+��C�E�|t;�{E����{      �   �   x��� C��0�v��s��	�gǸ9��S�7�X�R��
wkx���.\��-|����
yD�	Wv0$�r��c���<��!�r�N24�\6��hp�,m�����`@�Q�A�a���jG=z[��?Z;:%��V=zӎ^I�c�8�~ � ߒ'�      �   �  x����n�8���S�T��$���؞�@��=텕���,��y�>@�����2ib�u��@����|�!Y��n(���0�kW��wk�.L�+Q��bRKVWu��1M[���\V�KV�5��{�����'�tŋ?m��ѢNrn��=F?m�$�*.d��V��-8<�h^��Hr~єߓޝ�1̵4HM�(IK}��0���M!�aF������~ߺ��ˢ�Iߝ���ٺ89,����P����@�AYx@��S���	������F(��Ѕ�N�@�W�h���t��Dv��&��M�`��f:��9��G0��v}�b�B���:�[�⏾��Ễd��i/z�h�aF�������1��w?"�{��*�L�~�RdW2V�"d�w��1�O6������aOь�W�82�͗��}y ��L
��RkFO���%� $�!�w���ʾ�v?{��L`���ٷLb�~�w�Z~
��31�����Q�QN���#������N� #�e�I QD��˷C�=>��Xva�ڹ�����h�qT�Gg�ۗ��	<@��'��-�||������l�����D��7E���/ #�kE�g��6���r9z̟���6!5'g�s,٭�����|�Ã�Va����@�6m!�{�{��h@�lx�P�}��p��.Op�����ֻv������SS1z#s�G��&�|�oS���H�'L�F���׾����t0ڠN� /�	�Jv���;�B��xL�i��C*���0����aX6tGZ9�5&2Uk�u��8K��Io'�����0�#Cr	��Ќ�z���nr����X��{��AH*��h��E�hgHo0���{�0���#�B�d�R3olP��i�c�9$�	����r�CN�v�B���
�"��\8r*�9����F߰�9������N�g���˒	#/[?�����R@��g%�˗ �0)�Z�;�,��9�)�nv��B�]�sW~�`Vy�'���d��&/�����8 R��E�\1M:��:�(z6��!�c�옡�7.���ȓ��hN�6�μM���:�|)�O���7�����ߟ]䫳9��[�=�rmJ.�:�@�2b\��K�=ɦ�g����7�{�xu��,�`���	΃����$��\|n�����Xɷ���;�Bfdr�D��?ﮮ��o'�l      �   _   x����� ��w�.P���N��S]@���a0�*��Ls��1�W�݋@��ػc�R�Sf0�TK����[[���ZJ� �@9      �   =  x���;n�@Dk����%�+���M ���)|�vݤ��b%��Y%�I�.�NҶ�B�z]ϧ��|]�K����P�!�}�Rz�땐+���Dϗϯ���v��d���n�L��}�����9�d0�0uD�H������F�a����'M�ԩ� �,e�@���v!��4va� ��M�dY��.�C;� �>xR�0Q[죧 Ԑ��m�]��.�GY�� ����-v�f����bY��I�
�+�-���Ʈ>��F�A�\�~�U�~Ӗ����A#wmV�>#�����㞙�ך��      �   �   x���A
�0EדSxefL����u7�Cl"��iRJm�E�o7��	8Y焁�1�![0.��D9rF� �&�̓W:$�֧�n�ez	6$E��޹��W���0�PN߂^�4�;D ��������������@U$���۠��(�W5Л����{��z�j      �   �  x���=n�@���)r/�/�U9q`X�`��L�5��E!�mT�P�s��,�4� o��3�C�m���}!���}��+MӋ0�ز&v����V;-En*�|�� J.?��2�/����$��2�`�dOw�u�(~��S=B�l��
I��f��
I�>I���.����ӡ�aB�W�g��)��	\�7H�;�����t�0�"�EɪB_��Z��V��:�����G͢ ����f��=)>|5D��������4�`7�}_��<�[C���<ؓN:�/�u��Y�E[��yv}\B�Ǽ�$,�0G� ��<�!�A��]�5T�����>H��[q6l
���X�p�-!��^���k3Yv	ک���7hkU�R��2f�h��^[U����{�7�ٲiV�
Ifrk��q#LN�ƌ�Z���U�*�O��Ʋa��N8�ި	��u;��}��A��l&��!
D����Ob�XO���l=��h�%�!l�{�;� �NJjv�=R��c�o�^E^�s�ٗ�����Q��x�2�Ǣh�v���PU�ߴ{���[7 �*�Ux#/����]��8Y8�d���x�d_k���5ug�ڍ�:H���	�q%���j��GJq
��5GI7�a��� e����&f��_��S     