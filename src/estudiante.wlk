import materia.*
import carrera.*
import inscripcion.*

class Estudiante {
	var property materiasAprobadas
	var property carreras
	var creditos
	method creditos(){
		return creditos
	}
	method setCreditos(num){
		creditos+=num
	}
}
