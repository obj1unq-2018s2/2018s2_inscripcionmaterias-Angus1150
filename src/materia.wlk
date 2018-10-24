import estudiante.*
import carrera.*
import inscripcion.*

class Materia {
	
	var property carrera
	var property esDeAnio
	var property alumnosInsc
	var property doyCreditos
	var property cupo
	var property listaEspera
	
	method anotarAlumno(alumno){
		if(self.puedeCursar(alumno)&& self.alumnosInsc().size()<self.cupo()){
			self.alumnosInsc().add(alumno)
		}else if(self.puedeCursar(alumno)){
			self.listaEspera().add(alumno)
		}
	}
	method puedeCursar(alumno)= return self.perteneceACarrera(alumno)&& not self.yaLaAprobo(alumno) && not self.estaInscripto(alumno)

	method yaLaAprobo(alumno)=return alumno.materiasAprobadas().any{mater=>mater == self}
	
	method estaInscripto(alumno)= return self.alumnosInsc().any{alum=>alum == alumno}
	
	method perteneceACarrera(alumno)= return alumno.carreras().any{carr=>carr == self.carrera()}
	
	method aprobo(alumno){
		if(not self.yaLaAprobo(alumno)){
			alumno.materiasAprobadas().add(self)
			alumno.setCreditos(self.doyCreditos())
	    }
	}
	method darDeBaja(alumno){
		self.alumnosInsc().remove(alumno)
		self.anotarAlumno(self.listaEspera(1))
	}

}	//prerequisitos
class MateriaCorrelativa inherits Materia{
	var property mateNecesarias
	 
	override method puedeCursar(alumno){
		return super(alumno) && self.mateNecesarias() == alumno.materiasAprobadas()
	}
}
class MateriaConCreditos inherits Materia{
	var property credNecesarios
	
	override method puedeCursar(alumno){
		return super(alumno) && self.credNecesarios() == alumno.creditos()
	}
	
}
class MateriaPorAnio inherits Materia{
	var property materiasDeAnioAnt
	override method puedeCursar(alumno){
		return super(alumno) && alumno.materiasAprobadas().contains(self.materiasDeAnioAnt()) 
	}
}