import materia.*
import estudiante.*
import carrera.*


object inscripcion {
    
    method estudiantesEn(materia){
    	return materia.alumnosInsc()
    }
    method enEspera(materia){
    	return materia.listaEspera()
    	
    }
    method sePuedeInscribirEn(alumno,carrera){
    	if(alumno.carreras().any({carr=>carr == carrera})){
    		return carrera.materias().filter({mat=>mat.puedeCursar(alumno)})
    	}else{
    		return []
    	}
    }
    method seAnotoEn(alumno){
    	return alumno.materiasInsc()
    }
    method estaEnEspera(alumno){
    	return alumno.materiasEnEspera()
    }
    
}
