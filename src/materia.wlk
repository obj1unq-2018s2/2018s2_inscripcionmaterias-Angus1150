import estudiante.*
import carrera.*
import inscripcion.*

class Materia {
	
	var property esDeCarrera
	var property esDeAnio
	var property alumnosInsc
	var property doyCreditos
	var property cupo
	var property listaEspera
	
	method carrera(name){
		name.materias().add(self)
		esDeCarrera=name
	}
	
	method anotarAlumno(alumno){
		if(self.puedeCursar(alumno)&& self.alumnosInsc().size()<self.cupo()){ // TODO Vendría bien una subtarea para chequear cupo.
			self.alumnosInsc().add(alumno)
			alumno.materiasInsc().add(self)
		}else if(self.puedeCursar(alumno)){ // TODO Duplica validación.
			self.listaEspera().add(alumno)
			alumno.materiasEnEspera().add(self)
		}
	}
	
	// TODO El return acá no hace falta
	method puedeCursar(alumno)= return self.perteneceACarrera(alumno)&& 
								not self.yaLaAprobo(alumno) && not self.estaInscripto(alumno)

	// TODO Este método quedaría más prolijo en alumno
	method yaLaAprobo(alumno)=return alumno.materiasAprobadas().any{mater=>mater == self}
	
	// TODO Mejor usar contains en lugar de any en estos casos.
	method estaInscripto(alumno)= return self.alumnosInsc().any{alum=>alum == alumno}
	
	// TODO => contains!
	method perteneceACarrera(alumno)= return alumno.carreras().any{carr=>carr == self.esDeCarrera()}
	
	method aprobo(alumno){
		// TODO Si mirás este métod, verás que casi todo le estás pidiendo al alumno, este método estaría mucho mejor en alumno.
		if(not self.yaLaAprobo(alumno)){
			// TODO Específicamente acá hay dos tareas que siempre se deben hacer coordinadamente, sería mejor mandar un único mensaje que haga ambas cosas.
			// Rompe el encapsulamiento de alumno
			alumno.materiasAprobadas().add(self)
			alumno.setCreditos(self.doyCreditos())
	    }
	    
	    // TODO Debería tirar excepción si no va a hacer nada.
	}
	method darDeBaja(alumno){
		self.alumnosInsc().remove(alumno)
		self.anotarAlumno(self.listaEspera().first())
		self.listaEspera() // TODO Acá falta algo, si no esta línea no tiene sentido.
	}

}	//prerequisitos
class MateriaCorrelativa inherits Materia{
	var property mateNecesarias
	 
	override method puedeCursar(alumno){
		// TODO Dividir en subtareas.
		return super(alumno) && self.mateNecesarias().asSet().difference(alumno.materiasAprobadas().asSet()) == #{}
	}
}
class MateriaConCreditos inherits Materia{
	var property credNecesarios
	
	override method puedeCursar(alumno){
		return super(alumno) && self.credNecesarios() == alumno.creditos()
	}
	
}
class MateriaPorAnio inherits Materia{
	method materiasDeAnioAnt(anioActual, carrera){
		return carrera.materias().filter{mat=>mat.esDeAnio()== anioActual-1}
	}
	method difEntreConjuntos(alumno){ // TODO Nombre muy poco descriptivo.
	 return self.materiasDeAnioAnt(alumno.anioCursada(),self.esDeCarrera()).asSet().difference(
								alumno.materiasAprobadas().asSet())==#{}
	}
	
	override method puedeCursar(alumno){
		return super(alumno) && self.difEntreConjuntos(alumno) 
	}
}
class MateriaSinPreReq inherits Materia{}