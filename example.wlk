class Nave {
  var velocidad
  var direccion
  var combustible

  method velocidad()=
    velocidad

  method acelerar(cantidad) {
    velocidad = 10000.min(velocidad + cantidad)
  }

  method desacelerar(cantidad) {
    velocidad = 0.max(velocidad - cantidad)
  }

  method irHaciaElSol() {
    direccion = 10
  }

  method escaparDelSol() {
    direccion = -10
  }

  method ponerseParaleloAlSol() {
    direccion = 0
  }

  method acecarcarseUnPocoAlSol(){
    direccion += 10.min(direccion + 1)
  }

  method alejarseUnPocoDelSol() {
    direccion -= -10.max(direccion - 1)
  }

  method cargarCombustible(cantidad) {
    combustible += cantidad
  }

  method prepararViaje() {
    self.cargarCombustible(30000)
    self.acelerar(5000)
    self.condicionAdicional()
  }
  
  method condicionAdicional()
  method condicionAdicionalDeTranquilidad()

  method estaTranquila()=
    combustible >= 4000 and velocidad <= 12000 and
    self.condicionAdicionalDeTranquilidad()
  
  method estaDeRelajo()=
    self.estaTranquila()
}

class NaveDeBaliza inherits Nave {
  var baliza 
  const opciones = #{'verde', 'rojo', 'azul'}
  var cambioColor = false

  method cambioColor()=
    cambioColor

  method cambiarColorDeBaliza(colorNuevo) {
    if (!opciones.contains(colorNuevo.toLowerCase())) {
      self.error('El color nuevo debe ser verde, rojo o azul')
    }
    baliza = colorNuevo
    cambioColor = true
  }

  method baliza()=
    baliza
  
  override method condicionAdicional() {
    self.prepararViaje()
    self.cambiarColorDeBaliza('verde')
    self.ponerseParaleloAlSol()
  }

  override method condicionAdicionalDeTranquilidad()=
    baliza != 'verde'

  method recibirAmenaza() {
    self.irHaciaElSol();
    self.cambiarColorDeBaliza('rojo')
  }

  override method estaDeRelajo()=
    super() and self.cambioColor()
}
  

class NaveDePasajeros inherits Nave {
  const pasajeros 
  var racionesComida
  var racionesBebida

  var racionesComidaServida = 0
  
  method cargarRacionesComida(cantidad) {
    racionesComida += cantidad
  }

  method racionesComidaServida()=
    racionesComidaServida

  method cargarRacionesBebida(cantidad) {
    racionesBebida += cantidad
  }

  method descargarComida(cantidad) {
    racionesComida = 0.max(racionesComida - cantidad)
    racionesComidaServida += cantidad
  }

  method descargarBebida(cantidad) {
    racionesBebida = 0.max(racionesBebida - cantidad)
  }

  override method condicionAdicional() {
    self.prepararViaje()
    self.cargarRacionesBebida(4)
    self.cargarRacionesBebida(6)
    self.acecarcarseUnPocoAlSol()
  }

  method recibirAmenaza() {
    self.acelerar(self.velocidad() * 2)
    self.descargarComida(racionesComida - pasajeros)
    self.descargarBebida(racionesBebida - (pasajeros*2))
  }

  method tienePocaActividad()=
    self.racionesComidaServida() < 50
  
  override method estaDeRelajo()=
    super() and self.tienePocaActividad()

}

class NaveDeCombate inherits Nave {
  var esInvisible = true
  var misiblesDesplegados = false
  const property mensajesEmitidos = []

  method misiblesDesplegados()= misiblesDesplegados

  method ponerseVisible() {
    esInvisible = false
  }

  method ponerseInvisible() {
    esInvisible = true
  }

  method estaInvisible()=
    esInvisible

  method desplegarMisiles(){
    misiblesDesplegados = true
  }

  method replegarMisiles() {
    misiblesDesplegados = false
  }

  method emitirMensaje(mensaje) {
    mensajesEmitidos.add(mensaje)
  } 

  method primerMensajeEmitido() {
    if (mensajesEmitidos.isEmpty()) {
      self.error("La nave no ha emitido mensajes")
    }
    return mensajesEmitidos.first()
  }

  method ultimoMensajeEmitido() {
    if (mensajesEmitidos.isEmpty()) {
      self.error("La nave no ha emitido mensajes")
    }
    return mensajesEmitidos.last()
  }

  method emitioMensaje(mensaje) {
    if (mensajesEmitidos.isEmpty()) {
      self.error("La nave no ha emitido ningún mensaje")
    }
    mensajesEmitidos.contains(mensaje)
  }

  method esEscueta()=
    mensajesEmitidos.all({
      mensaje => mensaje.size() >= 30
    })

  override method condicionAdicional() {
    self.prepararViaje()
    self.ponerseVisible()
    self.replegarMisiles()
    self.acelerar(15000)
    self.emitirMensaje('Saliendo en misión')
  }

  override method condicionAdicionalDeTranquilidad()=
    !self.misiblesDesplegados()
  
  method recibirAmenaza() {
    self.acecarcarseUnPocoAlSol()
    self.acecarcarseUnPocoAlSol()
    self.emitioMensaje('Amenaza recibida')
  }
}

class NaveHospital inherits NaveDePasajeros {
  var quirofanosPreparados = false 

  method prepararQuirofano() {
    quirofanosPreparados = true
  }

  override method condicionAdicionalDeTranquilidad()=
    quirofanosPreparados
  
  override method recibirAmenaza() {
    super();
    self.prepararQuirofano() 
  }
}

class NaveDeCombateSigilosa inherits NaveDeCombate {
  override method condicionAdicionalDeTranquilidad()=
    super() and !self.estaInvisible()
  
  override method recibirAmenaza() {
    super();
    self.desplegarMisiles();
    self.ponerseInvisible()
  }
}
 
