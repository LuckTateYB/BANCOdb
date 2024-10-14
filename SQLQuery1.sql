create database BANCO;
use BANCO;
CREATE TABLE Clientes (
		ClienteID INT PRIMARY KEY IDENTITY,
		Nombre VARCHAR(100) NOT NULL,
		Apellido VARCHAR(100) NOT NULL,
		FechaNacimiento DATE,
		Direccion VARCHAR(255),
		Telefono VARCHAR(15),
		Email VARCHAR(100),
		FechaRegistro DATE DEFAULT GETDATE()
	);

	CREATE TABLE CuentasBancarias (
		CuentaID INT PRIMARY KEY IDENTITY,
		ClienteID INT FOREIGN KEY REFERENCES Clientes(ClienteID),
		NumeroCuenta VARCHAR(20) NOT NULL,
		TipoCuenta VARCHAR(20) NOT NULL,
		Saldo DECIMAL(18, 2) NOT NULL,
		FechaApertura DATE DEFAULT GETDATE(),
		EstadoCuenta VARCHAR(10) NOT NULL
	);

	CREATE TABLE Transacciones (
		TransaccionID INT PRIMARY KEY IDENTITY,
		CuentaID INT FOREIGN KEY REFERENCES CuentasBancarias(CuentaID),
		TipoTransaccion VARCHAR(10) NOT NULL, -- 'Credito' o 'Debito'
		Monto DECIMAL(18, 2) NOT NULL,
		FechaTransaccion DATE DEFAULT GETDATE(),
		Descripcion VARCHAR(255)
	);

	CREATE TABLE Prestamos (
		PrestamoID INT PRIMARY KEY IDENTITY,
		ClienteID INT FOREIGN KEY REFERENCES Clientes(ClienteID),
		MontoPrestamo DECIMAL(18, 2) NOT NULL,
		Interes DECIMAL(5, 2) NOT NULL,
		PlazoMeses INT NOT NULL,
		FechaPrestamo DATE DEFAULT GETDATE(),
		EstadoPrestamo VARCHAR(10) NOT NULL
	);

	CREATE TABLE TarjetasCredito (
		TarjetaID INT PRIMARY KEY IDENTITY,
		ClienteID INT FOREIGN KEY REFERENCES Clientes(ClienteID),
		NumeroTarjeta VARCHAR(16) NOT NULL,
		LimiteCredito DECIMAL(18, 2) NOT NULL,
		FechaExpiracion DATE NOT NULL,
		CVV INT NOT NULL,
		SaldoActual DECIMAL(18, 2) NOT NULL
	);

	CREATE TABLE TarjetasDebito (
		TarjetaDebitoID INT PRIMARY KEY IDENTITY,
		ClienteID INT FOREIGN KEY REFERENCES Clientes(ClienteID),
		NumeroTarjeta VARCHAR(16) NOT NULL,
		FechaExpiracion DATE NOT NULL,
		CVV INT NOT NULL,
		SaldoActual DECIMAL(18, 2) NOT NULL,
		CuentaID INT FOREIGN KEY REFERENCES CuentasBancarias(CuentaID)
	);

	CREATE TABLE Sucursales (
		SucursalID INT PRIMARY KEY IDENTITY,
		NombreSucursal VARCHAR(100) NOT NULL,
		DireccionSucursal VARCHAR(255),
		TelefonoSucursal VARCHAR(15)
	);

	CREATE TABLE Empleados (
		EmpleadoID INT PRIMARY KEY IDENTITY,
		NombreEmpleado VARCHAR(100) NOT NULL,
		ApellidoEmpleado VARCHAR(100) NOT NULL,
		FechaContratacion DATE DEFAULT GETDATE(),
		Posicion VARCHAR(50),
		SucursalID INT FOREIGN KEY REFERENCES Sucursales(SucursalID)
	);


	-- Insertamos personas en la tabla Clientes
	INSERT INTO Clientes (Nombre, Apellido, FechaNacimiento, Direccion, Telefono, Email, FechaRegistro)
	VALUES 
	('Juan', 'García', '1995-04-10', 'Av. Los gorriones, Miraflores', '999999999', 'juan.garcia@gmail.com', GETDATE()),
	('Maria', 'Mamani', '2000-05-15', 'Jr. Las Flores 465, San Borja', '988888888', 'mariama@gmail.com', GETDATE()),
	('Carlos', 'Picho', '2004-03-20', 'Calle Los Olivos 789, SJM', '977777777', 'carlos.picho@gmail.com', GETDATE()),
	('Xiomara', 'Torres', '1998-09-12', 'Av. La Paz, MVT', '966666666', 'XioTorres@gmail.com', GETDATE()),
	('Oscar', 'Ramirez', '1985-07-08', 'Jr. El Sol 628, SJL', '955555555', 'oscar.ramirez@gmail.com', GETDATE());

	-- Insertamos las Cuentas Bancarias (dos por cliente) en la tabla CuentasBancarias
	INSERT INTO CuentasBancarias (ClienteID, NumeroCuenta, TipoCuenta, Saldo, EstadoCuenta)
	VALUES
	(1, '100001', 'Ahorro', 1500.00, 'Activa'),
	(1, '100002', 'Corriente', 2500.00, 'Activa'),
	(2, '100003', 'Ahorro', 3000.00, 'Activa'),
	(2, '100004', 'Corriente', 4000.00, 'Activa'),
	(3, '100005', 'Ahorro', 5000.00, 'Activa'),
	(3, '100006', 'Corriente', 6000.00, 'Activa'),
	(4, '100007', 'Ahorro', 7000.00, 'Activa'),
	(4, '100008', 'Corriente', 8000.00, 'Activa'),
	(5, '100009', 'Ahorro', 9000.00, 'Activa'),
	(5, '100010', 'Corriente', 10000.00, 'Activa');




	-- Insertamos las tarjetas de Crédito de cada cliente en la tabla "TarjetasCredito"
	INSERT INTO TarjetasCredito (ClienteID, NumeroTarjeta, LimiteCredito, FechaExpiracion, CVV, SaldoActual)
	VALUES
	(1, '4000011111222233', 5000.00, '2027-08-01', 123, 1000.00),
	(2, '4000021111222233', 7000.00, '2026-07-01', 124, 2000.00),
	(3, '4000031111222233', 8000.00, '2025-06-01', 125, 3000.00),
	(4, '4000041111222233', 9000.00, '2028-05-01', 126, 4000.00),
	(5, '4000051111222233', 10000.00, '2027-04-01', 127, 5000.00),
	-- Al cliente 1 le colocamos una segunda tarjeta de crédito
	(1, '4000011111222244', 6000.00, '2029-09-01', 128, 2000.00);

	-- Insertar Tarjetas de Débito (para todos excepto al cliente 1) psdt. estamos originando max. 2 cuentas
	INSERT INTO TarjetasDebito (ClienteID, NumeroTarjeta, FechaExpiracion, CVV, SaldoActual, CuentaID)
	VALUES
	(2, '5000011111222233', '2026-07-01', 123, 1500.00, 3),
	(3, '5000021111222233', '2025-06-01', 124, 2500.00, 5),
	(4, '5000031111222233', '2028-05-01', 125, 3500.00, 7),
	(5, '5000041111222233', '2027-04-01', 126, 4500.00, 9);

	-- Insertamos las Sucursales
	INSERT INTO Sucursales (NombreSucursal, DireccionSucursal, TelefonoSucursal)
	VALUES
	('Centro de Lima', 'Av. Emancipación 123', '991234567'),
	('Plaza Lima Sur', 'Av. Paseo de la República 456', '992234567'),
	('Plaza Norte', 'Av. Túpac Amaru 789', '993234567'),
	('Mall del Sur', 'Av. Los Próceres 321', '994234567'),
	('Open Plaza', 'Av. El Sol 654', '995234567');

	-- Insertamos Empleados
	INSERT INTO Empleados (NombreEmpleado, ApellidoEmpleado, FechaContratacion, Posicion, SucursalID)
	VALUES
	('Jose', 'Espinoza', GETDATE(), 'Gerente', 1),
	('Lucia', 'Mendoza', GETDATE(), 'Cajero', 2),
	('Luis', 'Diaz', GETDATE(), 'Analista', 3),
	('Rosa', 'Cuba', GETDATE(), 'Asesor', 4),
	('Mateo', 'Cruzado', GETDATE(), 'Ejecutivo', 5);
		
	-- Añadiremos una columna a la Tabla Clientes ya que queremos saber donde fueron creadas sus cuentas.
	ALTER TABLE Clientes
	ADD SucursalID INT;

	-- Asignar cada cliente a una sucursal diferente
	UPDATE Clientes
	SET SucursalID = 1 WHERE ClienteID = 1; -- Centro de Lima
	UPDATE Clientes
	SET SucursalID = 2 WHERE ClienteID = 2; -- Plaza Lima Sur
	UPDATE Clientes
	SET SucursalID = 3 WHERE ClienteID = 3; -- Plaza Norte
	UPDATE Clientes
	SET SucursalID = 4 WHERE ClienteID = 4; -- Mall del Sur
	UPDATE Clientes
	SET SucursalID = 5 WHERE ClienteID = 5; -- Open Plaza;




--Procedimiento 1: Consultar el saldo de una cuenta
CREATE PROCEDURE consultarSaldoCuenta
	@CuentaID INT
AS
BEGIN
	--consultar el saldo
	select Saldo
	From CuentasBancarias
	where CuentaID = @CuentaID;
END;

--Procedimiento 2: Descuento mensual del 0.2% del saldo total
CREATE PROCEDURE aplicarDescuentoMensual
AS
BEGIN
	UPDATE CuentasBancarias
	SET Saldo = Saldo -(Saldo*0.002)
	where EstadoCuenta = 'Activa';
END;

-- TRIGGER 1: Actualizar el saldo después de una transacción
CREATE TRIGGER ActualizarSaldo
ON Transacciones
AFTER INSERT
AS
BEGIN
	declare @CuentaID INT, @Monto DECIMAL (18,2), @TipoTransaccion VARCHAR(10);
	
	--obtener valores
	SELECT @CuentaID = inserted.CuentaID, @Monto = inserted.Monto, @TipoTransaccion = inserted.TipoTransaccion
	from inserted;

	--Actualizar el saldo en funcion al tipo de transacción
	IF @TipoTransaccion = 'Credito'
	BEGIN
		update CuentasBancarias
		set Saldo = Saldo + @Monto
		where CuentaID = @CuentaID;
	END;
	ELSE IF @TipoTransaccion = 'Debito'
	BEGIN
		update CuentasBancarias
		set Saldo = Saldo - @Monto
		where CuentaID = @CuentaID;
	END;
END;

--CREAR UN PROCEDURE PARA REALIZAR TRANSACCIONES CON ROLLBACK

CREATE PROCEDURE realizarTransaccionConRollback
	@CuentaID INT,
	@TipoTransaccion VARCHAR(10),
	@Monto DECIMAL(18,2),
	@Descripcion VARCHAR(255)
AS
BEGIN
	BEGIN TRY
	BEGIN TRANSACTION;
	--verificar el saldo
	DECLARE @SaldoActual DECIMAL(18,2);
	SELECT @SaldoActual = Saldo from CuentasBancarias where CuentaID =@CuentaID;

	--para las transacciones de debito, verificar si hay suficiente saldo
	IF @TipoTransaccion = 'Debito' and @SaldoActual < @Monto
	BEGIN
		raiserror('Saldo insuficiente para la transaccion.', 16,1);
		ROLLBACK;
		RETURN;
	END
	-- al insertar esto activara el trigger
	INSERT INTO Transacciones(CuentaID, TipoTransaccion, Monto,Descripcion)
	values(@CuentaID,@TipoTransaccion,@Monto,@Descripcion);

	--confirmar si no hay errores
	COMMIT;
	END TRY

	BEGIN CATCH
		--SI ES Q EXISTE UN ERROR, ACTIVAR EL ROLLBACK
		rollback;
		print 'Error en la transaccion, se ha realizado un rollback';
	END CATCH;
END;

--3. Cursor para calcular la cantidad de transacciones
CREATE PROCEDURE ContarTransacciones
AS
BEGIN
    DECLARE @CuentaID INT, @TotalTransacciones INT;

    DECLARE cursorTransacciones CURSOR FOR
    SELECT CuentaID FROM CuentasBancarias;

    OPEN cursorTransacciones;

    FETCH NEXT FROM cursorTransacciones INTO @CuentaID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Calcular el número de transacciones
        SELECT @TotalTransacciones = COUNT(*) FROM Transacciones WHERE CuentaID = @CuentaID;

        -- Mostrar el resultado
        PRINT 'La cuenta ' + CAST(@CuentaID AS VARCHAR) + ' tiene ' + CAST(@TotalTransacciones AS VARCHAR) + ' transacciones.';

        FETCH NEXT FROM cursorTransacciones INTO @CuentaID;
    END

    CLOSE cursorTransacciones;
    DEALLOCATE cursorTransacciones;
END;


--Vista de Clientes y Cuentas Bancarias

CREATE VIEW VistaClienteCuenta
AS
SELECT
	c.ClienteID,
	c.Nombre,
	c.Apellido,
	c.Email,
	cb.NumeroCuenta,
	cb.TipoCuenta,
	cb.Saldo,
	cb.EstadoCuenta
from Clientes c
JOIN CuentasBancarias cb ON c.ClienteID = cb.ClienteID;

Select*
from VistaClienteCuenta;
