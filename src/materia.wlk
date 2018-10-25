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
		if(self.puedeCursar(alumno)&& self.alumnosInsc().size()<self.cupo()){
			self.alumnosInsc().add(alumno)
			alumno.materiasInsc().add(self)
		}else if(self.puedeCursar(alumno)){
			self.listaEspera().add(alumno)
			alumno.materiasEnEspera().add(self)
		}
	}
	method puedeCursar(alumno)= return self.perteneceACarrera(alumno)&& 
								not self.yaLaAprobo(alumno) && not self.estaInscripto(alumno)

	method yaLaAprobo(alumno)=return alumno.materiasAprobadas().any{mater=>mater == self}
	
	method estaInscripto(alumno)= return self.alumnosInsc().any{alum=>alum == alumno}
	
	method perteneceACarrera(alumno)= return alumno.carreras().any{carr=>carr == self.esDeCarrera()}
	
	method aprobo(alumno){
		if(not self.yaLaAprobo(alumno)){
			alumno.materiasAprobadas().add(self)
			alumno.setCreditos(self.doyCreditos())
	    }
	}
	method darDeBaja(alumno){
		self.alumnosInsc().remove(alumno)
		self.anotarAlumno(self.listaEspera().first())
		self.listaEspera()
	}

}	//prerequisitos
class MateriaCorrelativa inherits Materia{
	var property mateNecesarias
	 
	override method puedeCursar(alumno){
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
	method difEntreConjuntos(alumno){
	 return self.materiasDeAnioAnt(alumno.anioCursada(),self.esDeCarrera()).asSet().difference(
								alumno.materiasAprobadas().asSet())==#{}
	}
	
	override method puedeCursar(alumno){
		return super(alumno) && self.difEntreConjuntos(alumno) 
	}
}
class MateriaSinPreReq inherits Materia{}